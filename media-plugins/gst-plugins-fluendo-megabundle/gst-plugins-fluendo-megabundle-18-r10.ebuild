# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/jimmac-xcursors/jimmac-xcursors-0.0.1.ebuild,v 1.11 2006/01/31 14:57:12 josejx Exp $

inherit multilib

DESCRIPTION="Set of plugins for the gstreamer framework"
HOMEPAGE="http://www.fluendo.com/shop/product/complete-set-of-playback-plugins/"
SRC_URI="x86? ( fluendo-megabundle-${PV}.i386.tar.bz2 )
	amd64? ( fluendo-megabundle-${PV}.x86_64.tar.bz2 )"

LICENSE=""
SLOT="0.10"
KEYWORDS="~amd64 ~x86 x86 amd64"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=""
RESTRICT="fetch"

S=$WORKDIR

src_install() {
	dodir /usr/$(get_libdir)/gstreamer-${SLOT}
	cp -d -R  ${S}/codecs/gstreamer-${SLOT}/* \
		${D}/usr/$(get_libdir)/gstreamer-${SLOT}/ || die

	dodoc LICENSE.txt README.txt
}
