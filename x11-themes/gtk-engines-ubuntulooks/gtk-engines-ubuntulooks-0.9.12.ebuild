# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-industrial/gtk-engines-industrial-0.2.36.ebuild,v 1.6 2005/09/07 13:39:05 gustavoz Exp $

inherit eutils

MY_PN=ubuntulooks
MY_P=${MY_PN}_${PV}
DESCRIPTION="Ubuntu GTK 2 Theme Engine (based on Clearlooks)"
HOMEPAGE="http://packages.ubuntu.com/edgy/gnome/gtk2-engines-ubuntulooks"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/u/${MY_PN}/${MY_P}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=">=x11-libs/gtk+-2.8"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {

	unpack ${A}
	epatch ${FILESDIR}/${MY_P}-5.diff

}

src_compile() {
	econf
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"
	dodoc ChangeLog README
}
