# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

inherit eutils versionator

DESCRIPTION="elementary icons is an icon theme designed to be smooth, sexy, clear, and efficient"
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="http://code.launchpad.net/elementaryicons/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="x11-themes/gnome-icon-theme
	x11-themes/hicolor-icon-theme"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dodir /usr/share/icons
	for THEME in elementary elementary-mono-dark ; do
		cp -R "${THEME}" "${D}"/usr/share/icons/
	done
}
