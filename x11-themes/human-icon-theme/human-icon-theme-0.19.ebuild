# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

inherit eutils

DESCRIPTION="Human icon theme from ubuntu"
HOMEPAGE="http://www.ubuntu.com/"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/h/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND=">=x11-misc/icon-naming-utils-0.7.2
	 media-gfx/imagemagick
	 >=gnome-base/librsvg-2.12"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

src_unpack() {

	unpack ${A}
	epatch ${FILESDIR}/${PN}_${PV}-0ubuntu1.diff.gz

}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
