# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils gnome2-utils versionator

DESCRIPTION="Easily view data logged by zeitgeist"
HOMEPAGE="http://launchpad.net/gnome-activity-journal"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk
	dev-python/python-distutils-extra
	app-misc/zeitgeist"
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
