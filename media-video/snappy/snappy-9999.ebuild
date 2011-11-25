# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils git-2

DESCRIPTION="snappy is a gstreamer + clutter media player"
HOMEPAGE="https://github.com/luisbg/snappy"
EGIT_REPO_URI="git://github.com/luisbg/snappy.git"
EGIT_BOOTSTRAP="autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/gstreamer-0.10.20
		>=media-libs/gst-plugins-base-0.10.30
		>=media-libs/clutter-1.2.0
		>=media-libs/clutter-gst-1.0.0
		>=dev-libs/glib-2.24:2
		>=x11-libs/libXtst-1.2.0"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README THANKS ToDo
}
