# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
PYTHON_MODNAME="udevdiscover"

inherit distutils gnome2 versionator

DESCRIPTION="A helping tool for udev testers, coders, hackers and consumers"
HOMEPAGE="https://launchpad.net/udev-discover"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/gconf-python
	dev-python/pygobject:2[introspection]
	dev-python/python-gudev
	x11-libs/gtk+:3[introspection]
	gnome-base/gconf[introspection]
	x11-libs/gdk-pixbuf[introspection]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s:@PREFIX@:/usr:" udev-discover.in
	sed -i "s:/usr/local:/usr:" setup.cfg
}

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
	gnome2_pkg_preinst
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_pkg_postrm
}
