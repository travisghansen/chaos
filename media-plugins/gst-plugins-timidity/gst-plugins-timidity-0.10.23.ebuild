# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gst-plugins-bad/gst-plugins-bad-0.10.9.ebuild,v 1.1 2008/12/05 22:35:23 ssuominen Exp $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for timidity"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-sound/timidity++-2.13
	>=media-libs/libtimidity-0.1"

DEPEND="${RDEPEND}"
