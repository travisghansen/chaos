# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.16.0.ebuild,v 1.2 2006/09/12 15:21:36 dang Exp $

inherit gnome2

DESCRIPTION="The GNOME panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc eds"

RDEPEND=">=gnome-base/gnome-desktop-2.11.92
	>=x11-libs/gtk+-2.10
	>=gnome-base/libglade-2.5
	>=gnome-base/libgnome-2.13
	>=gnome-base/libgnomeui-2.5.4
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/orbit-2.4
	>=gnome-base/gnome-vfs-2.14.2
	>=x11-libs/libwnck-2.13.5
	>=gnome-base/gconf-2.6.1
	>=gnome-base/gnome-menus-2.11.1
	>=gnome-base/libbonobo-2
	>=sys-apps/dbus-0.60
	>=x11-libs/cairo-1.0.0
	media-libs/libpng
	eds? ( >=gnome-extra/evolution-data-server-1.6 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="--disable-scrollkeeper $(use_enable eds)"
}

src_unpack() {
	gnome2_src_unpack

	# FIXME : uh yeah, this is nice
	# We should patch in a switch here and send it upstream
	sed -i 's:--load:-v:' ${S}/gnome-panel/Makefile.in || die "sed failed"
}

pkg_postinst() {
	local entries="/etc/gconf/schemas/panel-default-setup.entries"
	if [ -e "$entries" ]; then
		einfo "setting panel gconf defaults..."
		GCONF_CONFIG_SOURCE=`${ROOT}/usr/bin/gconftool-2 --get-default-source`
		${ROOT}/usr/bin/gconftool-2 --direct --config-source \
			${GCONF_CONFIG_SOURCE} --load=${entries}
	fi

	# Calling this late so it doesn't process the GConf schemas file we already
	# took care of.
	gnome2_pkg_postinst
}
