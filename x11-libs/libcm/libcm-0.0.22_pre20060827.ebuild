# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

SRC_URI="http://www.schokokeks.org/~hanno/snapshots/${PN}-${PV##*_pre}.tar.bz2"

DESCRIPTION="Composite management library"
HOMEPAGE="http://www.gnome.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S="${WORKDIR}/${PN}"

DEPEND="dev-libs/glib
	x11-libs/libXxf86vm
	x11-libs/libXcomposite
	x11-libs/libXdamage
	>=media-libs/mesa-6.5.1_pre0"

src_compile() {
	eautoreconf || die
	econf || die
	emake || die
}

src_install() {
	einstall || die
}
