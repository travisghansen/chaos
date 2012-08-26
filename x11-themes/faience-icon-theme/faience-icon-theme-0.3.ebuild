# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

inherit eutils

DESCRIPTION="Humanity icon theme from ubuntu"
HOMEPAGE="http://tiheum.deviantart.com/art/Faience-icon-theme-255099649"
SRC_URI="http://www.deviantart.com/download/255099649/faience_icon_theme_by_tiheum-d47vo5d.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="x11-themes/gnome-icon-theme
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/share/icons
	for THEME in Faience Faience-Azur Faience-Claire Faience-Ocre ; do
		tar -zxf "${THEME}.tar.gz" -C "${D}"/usr/share/icons/
		chown -R root:root "${D}"/usr/share/icons/${THEME}
	done

	dodoc AUTHORS COPYING ChangeLog README
}
