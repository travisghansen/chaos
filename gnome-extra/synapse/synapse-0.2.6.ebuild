# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit versionator eutils gnome2-utils

DESCRIPTION="A GNOME launcher"
HOMEPAGE="https://launchpad.net/synapse-project"
SRC_URI="http://launchpad.net/${PN}-project/$(get_version_component_range 1-2)/$(get_version_component_range 1-3)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="zeitgeist"

VALA_SLOT="0.12"

DEPEND=">=dev-libs/glib-2.22.0
	>=dev-libs/libgee-0.5.2
	>=x11-libs/gtk+-2.20.0:2
	dev-libs/glib:2
	x11-libs/gtkhotkey
	dev-libs/libunique:1
	dev-libs/dbus-glib
	dev-libs/json-glib
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	zeitgeist?	( app-misc/zeitgeist
				  app-misc/zeitgeist-extensions[fts]
				  dev-libs/libzeitgeist
				)
	dev-lang/vala:${VALA_SLOT}"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/GNOME/GNOME;GTK/' data/synapse.desktop.in
}

src_configure() {
	local myconf
	myconf="--disable-indicator VALAC=$(type -p valac-${VALA_SLOT})"
	econf \
		$(use_enable zeitgeist) \
		${myconf}
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
