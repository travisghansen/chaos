# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/lib_mysqludf_json/lib_mysqludf_json-0.0.2.ebuild,v 1.1 2011/10/19 12:13:42 sbriesen Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_PN="${PN%-percona-server-bin}"

DESCRIPTION="MySQL UDFs to map relational data to the JSON format"
HOMEPAGE="http://www.mysqludf.org/lib_mysqludf_json/"
SRC_URI="http://www.mysqludf.org/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/percona-server-bin"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

# compile helper
_compile() {
	local CC="$(tc-getCC)"
	echo "${CC} ${@}" && "${CC}" "${@}"
}

pkg_setup() {
	MYSQL_PLUGINDIR="$(/opt/percona/bin/mysql_config --plugindir)"
	MYSQL_INCLUDE="$(/opt/percona/bin/mysql_config --include)"
}

src_prepare() {
	# remove precompiled object
	rm -f -- ${MY_PN}.so
}

src_compile() {
	_compile ${CFLAGS} -Wall -fPIC ${MYSQL_INCLUDE} \
		-shared ${LDFLAGS} -o ${MY_PN}.so ${MY_PN}.c
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe ${MY_PN}.so
	dodoc ${MY_PN}.sql
	dohtml ${MY_PN}.html
}

pkg_postinst() {
	elog
	elog "Please have a look at the documentation, how to"
	elog "enable/disable the UDF functions of ${PN}."
	elog
	elog "The documentation is located here:"
	elog "/usr/share/doc/${PF}"
	elog
}
