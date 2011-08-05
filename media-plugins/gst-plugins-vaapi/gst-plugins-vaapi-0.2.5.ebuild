# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib

MY_PN="gstreamer-vaapi"
DESCRIPTION="GStreamer VA-API plugins"
HOMEPAGE="http://www.splitted-desktop.com/~gbeauchesne/${MY_PN}/"
SRC_URI="http://www.splitted-desktop.com/~gbeauchesne/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/gstreamer-0.10.0                                                     
        >=media-libs/gst-plugins-base-0.10.16
		x11-libs/libva
		>=media-video/ffmpeg-0.6"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	econf  --enable-vaapisink-glx
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README COPYING NEWS  
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
