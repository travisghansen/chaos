# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit versionator eutils gnome2-utils

DESCRIPTION="A badass semantic File Browser thats powered by Zeitgeist"
HOMEPAGE="https://launchpad.net/sezen"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

VALA_SLOT="0.12"

DEPEND="dev-libs/glib
	x11-libs/gtk+
	dev-libs/dbus-glib
	dev-libs/libunique
	dev-libs/libzeitgeist
	dev-lang/vala:${VALA_SLOT}"
RDEPEND="${DEPEND}"

src_configure() {
		econf VALAC=$(type -p valac-${VALA_SLOT})
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"
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
