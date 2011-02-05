# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib

DESCRIPTION="Blu-ray ripper"
HOMEPAGE="http://www.makemkv.com/"
SRC_URI="http://www.makemkv.com/download/makemkv_v${PV}_bin.tar.gz
http://www.makemkv.com/download/makemkv_v${PV}_oss.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~amd64"

#IUSE=""
RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	dev-libs/openssl
	media-libs/mesa
	sys-libs/zlib
	sys-libs/glibc"

DEPEND="$RDEPEND"

src_prepare() {
	for DIR in oss bin;do
		cd "${WORKDIR}/${PN}_v${PV}_${DIR}"
		epatch "${FILESDIR}/DESTDIR-${PV}-${DIR}.patch"
		sed -i "s:/usr/lib:/usr/$(get_libdir):" makefile.linux
	done
}

src_configure() {
	einfo "nothing to do here"
}

src_compile() {
	for DIR in oss;do
		cd "${WORKDIR}/${PN}_v${PV}_${DIR}"
		emake -f makefile.linux || die "failed compiling ${PN}"
	done
}

src_install() {
	for DIR in oss bin;do
		cd "${WORKDIR}/${PN}_v${PV}_${DIR}"
		emake -f makefile.linux DESTDIR="${D}" install || die "failed installing ${PN}"
	done
}
