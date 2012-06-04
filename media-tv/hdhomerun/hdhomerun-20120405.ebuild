# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

EAPI=4
inherit base eutils

DESCRIPTION="library and cli tool to configure hdhomerun devices"
HOMEPAGE="http://www.silicondust.com/support/hdhomerun/downloads/linux/"
SRC_URI="http://download.silicondust.com/hdhomerun/hdhomerun_config_gui_${PV}.tgz
  http://download.silicondust.com/hdhomerun/libhdhomerun_${PV}.tgz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE="gtk"

S=${WORKDIR}/hdhomerun_config_gui

src_prepare() {
	epatch "${FILESDIR}"/destdir.patch
}

src_configure() {
	if use gtk;then
		base_src_configure
	fi
}

src_compile() {
	if ! use gtk;then
		cd ${WORKDIR}/libhdhomerun
	fi
	base_src_compile
}

src_install() {
	if use gtk;then
		emake DESTDIR="${D}" install
		insinto /usr/share/applications
		doins "${FILESDIR}"/${PN}.desktop
		insinto /usr/share/pixmaps
		doins "${FILESDIR}"/${PN}.png
	fi

	cd ${WORKDIR}/libhdhomerun
	dobin hdhomerun_config
	
	# manually install of not using gui 'make install'
	if ! use gtk;then
		dolib libhdhomerun.so
	fi

	# install these to work with dvbhdhomerun
	insinto /usr/include/libhdhomerun
	doins *.h
}

pkg_postinst() {
	einfo "You may want to update the firmware on your device"
	einfo "available here:"
	einfo "http://www.silicondust.com/support/hdhomerun/downloads/linux/"
}
