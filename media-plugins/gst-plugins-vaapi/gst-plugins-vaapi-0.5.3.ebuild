# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

MY_PN="gstreamer-vaapi"
DESCRIPTION="GStreamer VA-API plugins"
HOMEPAGE="http://gitorious.org/vaapi/gstreamer-vaapi"
SRC_URI="http://www.freedesktop.org/software/vaapi/releases/gstreamer-vaapi/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/pkgconfig
	>=media-libs/gstreamer-1.0.0
	>=media-libs/gst-plugins-base-1.0.0
	x11-libs/libva
	>=media-video/ffmpeg-0.6"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	econf  --enable-glx --enable-x11 --enable-drm --disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README COPYING.LIB NEWS  
	prune_libtool_files
}
