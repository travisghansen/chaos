# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils versionator

MY_PKG="Percona-Server"
MAJOR_MINOR=$(get_version_component_range 1-2)
RELEASE="20.2"
BUILD_NUMBER="116"

use x86 && M_ARCH="i686"
use amd64 && M_ARCH="x86_64"

SERVICE="percona"

SRC_URI="x86? ( http://www.percona.com/redir/downloads/${MY_PKG}-${MAJOR_MINOR}/${MY_PKG}-${PV}-${RELEASE}/Linux/binary/${MY_PKG}-${PV}-rel${RELEASE}-${BUILD_NUMBER}.Linux.i686.tar.gz )
		 amd64? ( http://www.percona.com/redir/downloads/${MY_PKG}-${MAJOR_MINOR}/${MY_PKG}-${PV}-${RELEASE}/Linux/binary/${MY_PKG}-${PV}-rel${RELEASE}-${BUILD_NUMBER}.Linux.x86_64.tar.gz ) "

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server."
HOMEPAGE="http://www.percona.com/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
DEPEND="userland_GNU? ( sys-process/procps )
        >=sys-apps/sed-4
        >=sys-apps/texinfo-4.7-r1
        >=sys-libs/readline-4.1
        >=sys-libs/zlib-1.2.3
		dev-libs/libaio"

RDEPEND="${DEPEND}
		virtual/mysql"

S="${MY_PKG}-${PV}-rel${RELEASE}-${BUILD_NUMBER}.Linux.${M_ARCH}"

src_prepare() {
	rm -rf "${S}/mysql-test"
	rm -rf "${S}/sql-bench"
}

src_install() {
	keepdir /var/lib/${SERVICE}
	keepdir /var/log/${SERVICE}
	keepdir /var/run/${SERVICE}

	dodir "/etc/${SERVICE}/"
	cp -R "${S}/support-files/"*.cnf "${D}/etc/${SERVICE}"
	cp "${FILESDIR}/my.cnf.sample" "${D}/etc/${SERVICE}/"
	rm -rf "${S}/support-files"
	mv "${S}/scripts/mysql_install_db" "${S}/bin"
	dodir "/opt/${SERVICE}"
	cp -R "${S}"/* "${D}/opt/${SERVICE}"

	chown -R mysql:mysql "${D}/var/lib/${SERVICE}"
	chown -R mysql:mysql "${D}/var/log/${SERVICE}"
	chown -R mysql:mysql "${D}/var/run/${SERVICE}"

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "percona"
	newinitd "${FILESDIR}/${PN}.init" "percona"
}

pkg_postinst() {
	einfo "You may wish to run emerge --config ${PN} at this time"
	einfo "to install this initial db"
	einfo ""
	einfo "Also note that the .sock is not in the normal"
	einfo "/var/run/mysql/mysqld.sock location so your applications may need to"
	einfo "be updated to use /var/run/percona/mysqld.sock"
	einfo "you may also create /etc/my.cnf and include"
	einfo ""
	einfo "[client]
socket = /var/run/percona/mysqld.sock
..."
}

pkg_config() {
	MY_SHAREDSTATEDIR="/opt/percona/share"
	MY_DATADIR="/var/lib/percona"

	local pwd1="a"
	local pwd2="b"
	local maxtry=15

	if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then

		einfo "Please provide a password for the mysql 'root' user now, in the"
		einfo "MYSQL_ROOT_PASSWORD env var or through the /root/.my.cnf file."
		ewarn "Avoid [\"'\\_%] characters in the password"
		read -rsp "    >" pwd1 ; echo

		einfo "Retype the password"
		read -rsp "    >" pwd2 ; echo

		if [[ "x$pwd1" != "x$pwd2" ]] ; then
			die "Passwords are not the same"
		fi
		MYSQL_ROOT_PASSWORD="${pwd1}"
		unset pwd1 pwd2
	fi

	local options=""
	local sqltmp="$(emktemp)"

	local help_tables="${ROOT}${MY_SHAREDSTATEDIR}/fill_help_tables.sql"
	[[ -r "${help_tables}" ]] \
	&& cp "${help_tables}" "${TMPDIR}/fill_help_tables.sql" \
	|| touch "${TMPDIR}/fill_help_tables.sql"
	help_tables="${TMPDIR}/fill_help_tables.sql"

	pushd "${TMPDIR}" &>/dev/null
	${ROOT}/opt/percona/bin/mysql_install_db --basedir=/opt/percona --datadir=/var/lib/percona --user mysql >"${TMPDIR}"/mysql_install_db.log 2>&1
	#${ROOT}opt/percona/bin/mysql_install_db --basedir=/opt/percona --datadir=/var/lib/percona --user mysql
	if [ $? -ne 0 ]; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR}"/mysql_install_db.log 1>&2
		die "Failed to run mysql_install_db. Please review /var/log/percona/mysqld.err AND ${TMPDIR}/mysql_install_db.log"
	fi
	popd &>/dev/null
	[[ -f "${ROOT}/${MY_DATADIR}/mysql/user.frm" ]] \
	|| die "MySQL databases not installed"
	chown -R mysql:mysql "${ROOT}/${MY_DATADIR}" 2>/dev/null
	chmod 0750 "${ROOT}/${MY_DATADIR}" 2>/dev/null

	# Figure out which options we need to disable to do the setup
	helpfile="${TMPDIR}/mysqld-help"
	${ROOT}/opt/percona/bin/mysqld --verbose --help >"${helpfile}" 2>/dev/null
	for opt in grant-tables host-cache name-resolve networking slave-start bdb \
		federated innodb ssl log-bin relay-log slow-query-log external-locking \
		ndbcluster \
		; do
		optexp="--(skip-)?${opt}" optfull="--skip-${opt}"
		egrep -sq -- "${optexp}" "${helpfile}" && options="${options} ${optfull}"
	done
	# But some options changed names
	egrep -sq external-locking "${helpfile}" && \
	options="${options/skip-locking/skip-external-locking}"

	${ROOT}/opt/percona/bin/mysql_tzinfo_to_sql "${ROOT}/usr/share/zoneinfo" > "${sqltmp}" 2>/dev/null

	if [[ -r "${help_tables}" ]] ; then
		cat "${help_tables}" >> "${sqltmp}"
	fi

	einfo "Creating the mysql database and setting proper"
	einfo "permissions on it ..."

	local socket="${ROOT}/var/run/percona/mysqld${RANDOM}.sock"
	local pidfile="${ROOT}/var/run/percona/mysqld${RANDOM}.pid"
	local mysqld="${ROOT}/opt/percona/bin/mysqld \
		${options} \
		--user=mysql \
		--basedir=${ROOT}/opt/percona \
		--datadir=${ROOT}/${MY_DATADIR} \
		--max_allowed_packet=8M \
		--net_buffer_length=16K \
		--default-storage-engine=MyISAM \
		--lc-messages-dir=/opt/percona/share
		--general-log=true
		--general-log-file=/var/log/percona/mysqld.log
		--socket=${socket} \
		--pid-file=${pidfile}"
	#einfo "About to start mysqld: ${mysqld}"
	ebegin "Starting mysqld"
	${mysqld} 2>/dev/null &
	rc=$?
	while ! [[ -S "${socket}" || "${maxtry}" -lt 1 ]] ; do
		maxtry=$((${maxtry}-1))
		echo -n "."
		sleep 1
	done
	eend $rc

	if ! [[ -S "${socket}" ]]; then
		die "Completely failed to start up mysqld with: ${mysqld}"
	fi

	ebegin "Setting root password"
	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="UPDATE mysql.user SET Password = PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE USER='root'"
	"${ROOT}/usr/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-e "${sql}"
	eend $?

	ebegin "Loading \"zoneinfo\", this step may require a few seconds ..."
	"${ROOT}/opt/percona/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-uroot \
		-p"${MYSQL_ROOT_PASSWORD}" \
		mysql < "${sqltmp}"
	rc=$?
	eend $?
	[ $rc -ne 0 ] && ewarn "Failed to load zoneinfo!"

	# Stop the server and cleanup
	einfo "Stopping the server ..."
	kill $(< "${pidfile}" )
	rm -f "${sqltmp}"
	wait %1
	einfo "Done"
#mysql_install_db --datadir=/var/lib/percona/ --user mysq
}
