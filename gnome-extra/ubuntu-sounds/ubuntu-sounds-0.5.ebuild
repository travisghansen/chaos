# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

DESCRIPTION="Human icon theme from ubuntu"
HOMEPAGE="http://www.ubuntu.com/"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/u/${PN}/${PN}_${PV}.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="!gnome-extra/gnome-audio"

DEPEND="${RDEPEND}"

src_compile() {

	einfo "Nothing to be done, continuing..."

}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
}
