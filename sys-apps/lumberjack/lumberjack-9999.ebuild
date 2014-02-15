# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

EGIT_REPO_URI="git://github.com/jordansissel/lumberjack.git"
if [[ ${PV} != *9999* ]] ; then
	EGIT_COMMIT="tags/$(echo ${PV//_/-} | tr '[:lower:]' '[:upper:]' )"
fi

EGIT_BRANCH="old/lumberjack-c"

if [[ ${PV} == *9999* ]]; then
	#KEYWORDS="-*"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Cuts logs in preparation for processing elsewhere"
HOMEPAGE="https://github.com/jordansissel/lumberjack"
LICENSE=""
RESTRICT="mirror"
SLOT="0"

DEPEND="dev-libs/openssl
	dev-libs/jemalloc
	=net-libs/zeromq-2*
	sys-libs/zlib"

#RDEPEND="${DEPEND}"

src_compile() {
	VENDOR="" CFLAGS="" make || die "failed to compile"
}

src_install(){
	dobin build/bin/lumberjack

	dodir /etc/${PN}/watch.d
	insinto /etc/${PN}/watch.d
	doins ${FILESDIR}/lumberjack.watch.sample

	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
}

pkg_postinst() {
	elog "You may place *.watch files in /etc/${PN}/watch.d"
	elog "each file may contain a list of files ( 1 file per line)"
	elog "to be watched by ${PN}"
}
