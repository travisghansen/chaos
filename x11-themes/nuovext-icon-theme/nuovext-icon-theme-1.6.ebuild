# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/jimmac-xcursors/jimmac-xcursors-0.0.1.ebuild,v 1.11 2006/01/31 14:57:12 josejx Exp $

MY_P="nuoveXT"
DESCRIPTION="The goal of nuoveXT is to provide a very complete set of icons for
both Gnome and KDE."
HOMEPAGE="http://nuovext.pwsp.net/"
SRC_URI="http://nuovext.pwsp.net/files/${MY_P}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=""

S=${WORKDIR}

src_install() {
	dodir /usr/share/icons/${MY_P}
	cp -R  ${MY_P}-${PV}/* \
		${D}/usr/share/icons/${MY_P}/ || die
}
