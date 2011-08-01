# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-bad/gst-plugins-bad-0.10.9.ebuild,v 1.1 2008/12/05 22:35:23 ssuominen Exp $

inherit gst-plugins-bad

DESCRIPTION="timidity plugin for GStreamer - based off of plugins-bad"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN/timidity/bad}/${P/timidity/bad}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.21
	>=media-libs/gstreamer-0.10.21
	>=media-sound/timidity++-2.13
	>=media-libs/libtimidity-0.1"

DEPEND="${RDEPEND}"
