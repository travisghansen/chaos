# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils versionator eutils gnome2-utils

DESCRIPTION="A screencasting program created with design in mind."
HOMEPAGE="https://launchpad.net/kazam"
#SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
SRC_URI="http://distfiles.one-gear.com/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pygtk
	dev-python/librsvg-python
	dev-libs/keybinder[python]
	dev-python/python-xlib
	media-video/ffmpeg[alsa,encode,X,x264]"
RDEPEND="${DEPEND}"

pkg_preinst() {
	type distutils_pkg_preinst &>/dev/null && distutils_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	type distutils_pkg_postinst &>/dev/null && distutils_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	type distutils_pkg_postrm &>/dev/null && distutils_pkg_postrm
	gnome2_icon_cache_update
}
