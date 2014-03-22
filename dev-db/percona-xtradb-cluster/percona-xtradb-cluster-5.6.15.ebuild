# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

#TODO: perhaps make a wrapper mysqld script to export LD_PATH
#TODO: percona uses jemalloc

EAPI=5

inherit cmake-utils eutils flag-o-matic multilib prefix systemd versionator

MY_PN="Percona-XtraDB-Cluster"
PKG_RELEASE="25.5"

# http://www.percona.com/redir/downloads/Percona-XtraDB-Cluster-56/release-5.6.15-25.5/source/mysql-dubious-exports.patch
# http://www.percona.com/redir/downloads/Percona-XtraDB-Cluster-56/release-5.6.15-25.5/source/Percona-XtraDB-Cluster-5.6.15.tar.gz
# http://www.percona.com/redir/downloads/Percona-XtraDB-Cluster-56/release-5.6.15-25.5/source/percona-xtradb-cluster-galera.tar.gz
BASE_URI="http://www.percona.com/redir/downloads"
MAJOR_MINOR=$(get_version_component_range 1-2)
SOURCE_DIR_URI="${BASE_URI}/${MY_PN}-${MAJOR_MINOR//./}/release-${PV}-${PKG_RELEASE}/source"


SERVICE="percona"
MY_PREFIX="/opt/${SERVICE}"

SRC_URI="${SOURCE_DIR_URI}/${MY_PN}-${PV}.tar.gz -> ${MY_PN}-${PV}-rel${PKG_RELEASE}.tar.gz
	${SOURCE_DIR_URI}/${PN}-galera.tar.gz -> ${PN}-galera-${PV}.tar.gz"

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server."
HOMEPAGE="http://www.percona.com/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
SLOT="0"
IUSE=""

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
DEPEND="userland_GNU? ( sys-process/procps )
		>=dev-db/xtrabackup-bin-2.1.4
		net-misc/socat
		sys-apps/iproute2
		sys-apps/pv
		net-analyzer/openbsd-netcat
		sys-apps/xinetd
		dev-libs/libevent
		>=dev-libs/openssl-1.0.1f
        >=sys-apps/sed-4
        >=sys-apps/texinfo-4.7-r1
        >=sys-libs/readline-4.1
        >=sys-libs/zlib-1.2.3
		dev-libs/libaio
		dev-util/scons
		dev-libs/check
		sys-libs/ncurses[tinfo]"

RDEPEND="${DEPEND}
		virtual/mysql"

#Percona-XtraDB-Cluster-5.6.15
S="${WORKDIR}/${MY_PN}-${PV}"

#percona-xtradb-cluster-galera
GALERA_S="${WORKDIR}/${PN}-galera"

_install_prepare() {
	cd ${S}
	local BASE_DIR="${D}${MY_PREFIX}"
	rm -rf "${BASE_DIR}/share/mysql-test"
	rm -rf "${BASE_DIR}/share/mysql/sql-bench"
	
	# they use flags that do not work with netcat/netcat6
	# nc -dl
	sed -i \
		-e "s|which nc|which nc.openbsd|" \
		"${BASE_DIR}"/bin/wsrep_sst_xtrabackup || die "failed to filter wsrep_sst_xtrabackup"
		
	sed -i \
		-e "s|tcmd=\"nc|tcmd=\"nc.openbsd|" \
		"${BASE_DIR}"/bin/wsrep_sst_xtrabackup || die "failed to filter wsrep_sst_xtrabackup"
		
	# they use flags that do not work with netcat/netcat6
	# nc -dl
	sed -i \
		-e "s|which nc|which nc.openbsd|" \
		"${BASE_DIR}"/bin/wsrep_sst_xtrabackup-v2 || die "failed to filter wsrep_sst_xtrabackup-v2"
		
	sed -i \
		-e "s|tcmd=\"nc|tcmd=\"nc.openbsd|" \
		"${BASE_DIR}"/bin/wsrep_sst_xtrabackup-v2 || die "failed to filter wsrep_sst_xtrabackup-v2"
		
	sed -i \
		-e "s|/usr/bin/clustercheck|/opt/percona/bin/clustercheck|" \
		"${BASE_DIR}"/xinetd.d/mysqlchk || die "failed to filter mysqlchk"
}

src_prepare() {
	epatch ${FILESDIR}/mysql-dubious-exports.patch || die "failed applying patch"
}

src_configure() {
	mycmakeargs+=(
		-DDEFAULT_CHARSET=utf8
		-DDEFAULT_COLLATION=utf8_general_ci
	)
	mycmakeargs+=( -DWITH_SSL=system )
	#mycmakeargs+=( -DWITH_SSL=bundled )
	
	CMAKE_BUILD_TYPE="RelWithDebInfo"
	
	mycmakeargs+=(
		-DENABLED_LOCAL_INFILE=1
		-DEXTRA_CHARSETS=all
		-DMYSQL_USER=mysql
		-DMYSQL_UNIX_ADDR=${EPREFIX}/var/run/percona/mysqld.sock
		-DWITH_READLINE=1
		-DWITH_LIBEDIT=0
		-DWITH_ZLIB=system
		-DWITHOUT_LIBWRAP=1
		-DWITH_PAM=1
		-DWITH_WSREP=1
	)
	
	# Storage engines
	mycmakeargs+=(
		-DWITH_ARCHIVE_STORAGE_ENGINE=1
		-DWITH_BLACKHOLE_STORAGE_ENGINE=1
		-DWITH_CSV_STORAGE_ENGINE=1
		-DWITH_HEAP_STORAGE_ENGINE=1
		-DWITH_INNOBASE_STORAGE_ENGINE=1
		-DWITH_INNODB_MEMCACHED=1
		-DWITH_MYISAMMRG_STORAGE_ENGINE=1
		-DWITH_MYISAM_STORAGE_ENGINE=1
		-DWITH_PARTITION_STORAGE_ENGINE=1
		-DWITH_PERFSCHEMA_STORAGE_ENGINE=1
		-DWITH_FEDERATED_STORAGE_ENGINE=1
	)

	mycmakeargs+=(
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}${MY_PREFIX}
		-DMYSQL_DATADIR=${EPREFIX}/var/lib/percona
		-DSYSCONFDIR=${EPREFIX}/etc/percona
		-DINSTALL_BINDIR=bin
		-DINSTALL_DOCDIR=docs
		-DINSTALL_DOCREADMEDIR=docs
		-DINSTALL_INCLUDEDIR=include
		-DINSTALL_INFODIR=share/info
		-DINSTALL_LIBDIR=${MY_PREFIX}/lib
		-DINSTALL_MANDIR=man
		-DINSTALL_MYSQLDATADIR=${EPREFIX}/var/lib/percona
		-DINSTALL_MYSQLSHAREDIR=share
		-DINSTALL_MYSQLTESTDIR=share/mysql-test
		-DINSTALL_PLUGINDIR=${MY_PREFIX}/lib/mysql/plugin
		-DINSTALL_SBINDIR=bin
		-DINSTALL_SCRIPTDIR=scripts
		-DINSTALL_SQLBENCHDIR=share/mysql
		-DINSTALL_SUPPORTFILESDIR=support-files
		-DWITH_COMMENT="Gentoo Linux ${PF}"
	)
	
	#mycmakeargs+=( -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF )
	#mycmakeargs+=( -DCMAKE_EXE_LINKER_FLAGS='-ltcmalloc' -DWITH_SAFEMALLOC=OFF )

	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	CXXFLAGS="${CXXFLAGS} -felide-constructors -fno-rtti"
	# As of 5.7, exceptions are used!
	CXXFLAGS="${CXXFLAGS} -fno-exceptions"
	export CXXFLAGS

	# bug #283926, with GCC4.4, this is required to get correct behavior.
	append-flags -fno-strict-aliasing

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	
	# install UDF plugins
	# must be done after main install as we used compiled/installed header
	cd ${S}/UDF
	./configure --prefix=${MY_PREFIX} --includedir="${D}${MY_PREFIX}/include"
	emake
	emake DESTDIR="${D}" install

	# install galera
	cd ${GALERA_S}
	scons -j20 tests=0 boost=1 ssl=1 revno=0 garb/garbd libgalera_smm.so
	exeinto ${MY_PREFIX}/lib
	doexe libgalera_smm.so

	exeinto ${MY_PREFIX}/bin
	doexe garb/garbd

	#TODO: need to install garb/files/garb.{cnf,sh} for init script

	_install_prepare	

	keepdir /var/lib/${SERVICE}
	keepdir /var/log/${SERVICE}
	keepdir /var/run/${SERVICE}

	dodir "/etc/${SERVICE}/"
	cp -R "${D}${MY_PREFIX}/support-files/"*.cnf "${D}/etc/${SERVICE}"
	cp -a "${D}${MY_PREFIX}/support-files/wsrep_notify" "${D}/etc/${SERVICE}"
	cp "${FILESDIR}/my.cnf.sample" "${D}/etc/${SERVICE}/"
	rm -rf "${D}${MY_PREFIX}/support-files"
	mv "${D}${MY_PREFIX}/scripts/mysql_install_db" "${D}${MY_PREFIX}/bin"
	dodir "/opt/${SERVICE}"

	cp -a ${S}/percona-xtradb-cluster-tests ${D}${MY_PREFIX}

	chown -R mysql:mysql "${D}/var/lib/${SERVICE}"
	chown -R mysql:mysql "${D}/var/log/${SERVICE}"
	chown -R mysql:mysql "${D}/var/run/${SERVICE}"

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "percona"
	newinitd "${FILESDIR}/${PN}.init" "percona"
	dodir /etc/profile.d
	insinto /etc/profile.d
	doins "${FILESDIR}"/percona-bin-path.sh

	insinto /etc/xinetd.d/
	doins "${D}${MY_PREFIX}"/xinetd.d/mysqlchk

	cp "${FILESDIR}/mysqld-post.sh" "${D}${MY_PREFIX}/bin/mysqld-post"
	chmod +x "${D}${MY_PREFIX}/bin/mysqld-post"

	systemd_newtmpfilesd "${FILESDIR}"/${PN}.tmpfile ${SERVICE}.conf || die
	systemd_newunit "${FILESDIR}"/${PN}.service ${SERVICE}.service || die
}

pkg_postinst() {
	einfo "You may wish to run emerge --config ${PN} at this time"
	einfo "to install the initial db"
	einfo ""
	einfo "Also note that the .sock is not in the normal"
	einfo "/var/run/mysql/mysqld.sock location so your applications may need to"
	einfo "be updated to use /var/run/percona/mysqld.sock"
	einfo "you may also create /etc/my.cnf and include"
	einfo ""
	einfo "[client]
socket = /var/run/percona/mysqld.sock
..."
	einfo ""
	einfo "an sh file has been installed to /etc/profile.d/percona-bin-path.sh"
	einfo "making the percona binary path takes precedence over standard mysql"
	einfo "if this is not desired simply comment the line out in the file"
	einfo ""
	einfo "you could also place the same logic into your .bashrc"
	einfo "please run 'soure /etc/profile' to reload your current shell"

	ewarn "You *must* copy /etc/percona/my.cnf.sample to"
	ewarn "/etc/percona/my.cnf and then edit as desired"

	einfo ""
	einfo "you have installed the cluster flavor"
	einfo "http://www.percona.com/doc/percona-xtradb-cluster/installation.html"
	einfo ""
	einfo "you may want to copy /etc/${SERVICE}/wsrep.cnf.sample"
	einfo "to /etc/${SERVICE}/wsrep.cnf and use:"
	einfo "!include /etc/${SERVICE}/wsrep.cnf"
	einfo "in your standard /etc/${SERVICE}/my.cnf"
	einfo ""
	einfo "/etc/xinetd.d/mysqlchk has been installed"
	einfo "this is useful for monitoring/health checks with load balancing"
	einfo "systems.  In or to make use of it you must add the following to"
	einfo "/etc/services:"
	einfo "mysqlchk        9200/tcp                # mysqlchk"
	einfo ""
	einfo "Additionally make sure xinetd is added to default runlevel etc"
	einfo "as appropriate. More info is available here:"
	einfo "https://github.com/olafz/percona-clustercheck"

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
	${ROOT}/opt/percona/bin/mysql_install_db --basedir=/opt/percona \
	--datadir=/var/lib/percona --user mysql \
	--defaults-file=${ROOT}/etc/percona/my.cnf.sample \
	>"${TMPDIR}"/mysql_install_db.log 2>&1
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
		--defaults-file=${ROOT}/etc/percona/my.cnf.sample
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
