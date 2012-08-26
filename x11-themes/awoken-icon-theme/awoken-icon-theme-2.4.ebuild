# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

inherit eutils

DESCRIPTION="Powerful and customizable icon theme"
HOMEPAGE="http://alecive.deviantart.com/art/AwOken-163570862"
SRC_URI="http://www.deviantart.com/download/163570862/awoken_by_alecive-d2pdw32.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="media-gfx/imagemagick
	x11-themes/gnome-icon-theme
	x11-themes/hicolor-icon-theme
	x11-themes/ubuntu-mono"

DEPEND="${RDEPEND}"

S="${WORKDIR}/AwOken-2.4"

src_install() {
	dodir /usr/share/icons
	for THEME in AwOken AwOkenDark AwOkenWhite ; do
		tar -zxf "${THEME}.tar.gz" -C "${D}"/usr/share/icons/
		chown -R root:root "${D}"/usr/share/icons/${THEME}
		chmod -R u+rwX,go+rX "${D}"/usr/share/icons/${THEME}
	done

	chmod +x "${D}"/usr/share/icons/AwOken/awoken-icon-theme-customization
	dosym /usr/share/icons/AwOken/awoken-icon-theme-customization \
		/usr/bin/awoken-icon-theme-customization
}
