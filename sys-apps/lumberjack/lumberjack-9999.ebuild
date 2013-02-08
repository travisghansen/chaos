# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

EGIT_REPO_URI="git://github.com/jordansissel/lumberjack.git"
if [[ ${PV} != *9999* ]] ; then
	EGIT_COMMIT="tags/$(echo ${PV//_/-} | tr '[:lower:]' '[:upper:]' )"
fi

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

	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
}
