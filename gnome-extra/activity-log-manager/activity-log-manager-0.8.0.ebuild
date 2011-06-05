# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"

inherit distutils gnome2-utils versionator

DESCRIPTION="Activity Log Manager for Zeitgeist"
HOMEPAGE="https://launchpad.net/history-manager"
SRC_URI="http://launchpad.net/history-manager/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-misc/zeitgeist-0.8.0
	dev-python/pygtk"

RDEPEND="${DEPEND}"

src_configure() {
	:
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
