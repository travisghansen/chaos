# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

MY_PN="mirage-engine"
MY_PV="${MY_PN}-${PV}"

DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=42755"
SRC_URI="http://ultra.hivalley.com/data/${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6"

S=${WORKDIR}/${MY_PV}

src_compile() {
	
	eautoreconf
	econf
	emake

}

src_install() {

	make DESTDIR=${D} install

}

