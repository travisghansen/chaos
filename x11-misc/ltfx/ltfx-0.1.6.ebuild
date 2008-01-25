# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1.ebuild,v 1.6 2005/01/01 15:15:35 eradicator Exp $

DESCRIPTION="Linux Test For X"
HOMEPAGE="http://sourceforge.net/projects/ltfx/"
SRC_URI="http://easynews.dl.sourceforge.net/sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 alpha sparc"
IUSE=""

DEPEND=""

RDEPEND="dev-lang/python"

src_compile(){

	einfo "This is the install part"
	emake BINPATH="/usr/bin" || die "compile problem"
}

src_install() {

	dobin ltfx
	dobin digwin

	dodoc AUTHORS README COPYING CHANGELOG 
	
}
