# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
#PYTHON_MODNAME="udevdiscover"

inherit distutils gnome2 versionator

DESCRIPTION="receive and send sms with gnome and Android"
HOMEPAGE="https://launchpad.net/blubphone"
# https://launchpad.net/blubphone/trunk/12.07.22/+download/blubphone_12.07.22.tar.gz
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS="-*"
IUSE=""

DEPEND="dev-libs/gobject-introspection
	x11-libs/libnotify[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/gdk-pixbuf[introspection]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

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
