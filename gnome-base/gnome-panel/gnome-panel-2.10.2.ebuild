# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.10.2.ebuild,v 1.14 2006/09/05 01:41:56 kumba Exp $

inherit eutils gnome2

DESCRIPTION="The GNOME panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~ppc64 sparc x86"
IUSE="doc eds static"

RDEPEND=">=x11-libs/gtk+-2.5.4
	>=x11-libs/libwnck-2.9.92
	>=gnome-base/orbit-2.4
	>=gnome-base/gnome-vfs-2.9.1
	>=gnome-base/gnome-desktop-2.9.91
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/libglade-2.5
	>=gnome-base/libgnome-2.1.1
	>=gnome-base/libgnomeui-2.5.4
	>=gnome-base/gconf-2.6.1
	>=gnome-base/gnome-menus-2.9.4.1
	media-libs/libpng
	eds? ( >=gnome-extra/evolution-data-server-1.1.4.2 )
	!gnome-extra/system-tray-applet"
# we need eds-1.1 for libecal-1.2

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/pkgconfig
	>=dev-util/intltool-0.31
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

USE_DESTDIR="1"
G2CONF="${G2CONF} $(use_enable eds) $(use_enable static)"

src_compile() {

	gnome2_src_configure

	# FIXME : uh yeah, this is nice
	# We should patch in a switch here and send it upstream
	sed -i 's:--load:-v:' gnome-panel/Makefile || die

	emake || die

}

pkg_postinst() {

	local entries="/etc/gconf/schemas/panel-default-setup.entries"
	if [ -e "$entries" ]; then
		einfo "setting panel gconf defaults..."
		GCONF_CONFIG_SOURCE=`${ROOT}/usr/bin/gconftool-2 --get-default-source`
		${ROOT}/usr/bin/gconftool-2 --direct --config-source \
			${GCONF_CONFIG_SOURCE} --load=${entries}
	fi

	local updater=`which gtk-update-icon-cache`
	if [ -x "$updater" ]; then
		einfo "Updating icon cache"
		$updater -qf ${ROOT}/usr/share/icons/hicolor
	fi

	# Calling this late so it doesn't process the GConf schemas file we already
	# took care of.
	gnome2_pkg_postinst

}

