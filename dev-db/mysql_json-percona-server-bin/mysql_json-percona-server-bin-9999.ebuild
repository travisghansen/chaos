# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/lib_mysqludf_json/lib_mysqludf_json-0.0.2.ebuild,v 1.1 2011/10/19 12:13:42 sbriesen Exp $

EAPI=4

inherit eutils git-2 toolchain-funcs

MY_PN="${PN%-percona-server-bin}"

DESCRIPTION="MySQL UDF for parsing JSON"
HOMEPAGE="https://github.com/kazuho/mysql_json"
EGIT_REPO_URI="git://github.com/kazuho/mysql_json.git"

#LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/percona-server-bin"
RDEPEND="${DEPEND}"

# compile helper
_compile() {
	local CC="$(tc-getCXX)"
	echo "${CC} ${@}" && "${CC}" "${@}"
}

pkg_setup() {
	MYSQL_PLUGINDIR="$(/opt/percona/bin/mysql_config --plugindir)"
	MYSQL_INCLUDE="$(/opt/percona/bin/mysql_config --include)"
}

src_prepare() {
	git submodule init
	git submodule update
}

src_compile() {
	_compile ${CFLAGS} -shared -fPIC -Wall -g ${MY_PN}.cc -o ${MY_PN}.so
}

src_install() {
	exeinto "${MYSQL_PLUGINDIR}"
	doexe ${MY_PN}.so
	dodoc README
}

pkg_postinst() {
	elog
	elog "Please have a look at the documentation, how to"
	elog "enable/disable the UDF functions of ${PN}."
	elog
	elog "The documentation is located here:"
	elog "http://blog.kazuhooku.com/2011/09/mysqljson-mysql-udf-for-parsing-json.html"
	elog
	elog "For example:"
	elog "CREATE FUNCTION json_get returns string soname 'mysql_json.so';"
}
