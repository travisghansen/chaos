# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils versionator gnome2

DESCRIPTION="Zeitgeist is a service which logs the users's activities and events"
HOMEPAGE="https://launchpad.net/${PN}"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pygtk
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
