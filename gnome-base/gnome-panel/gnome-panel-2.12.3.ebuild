# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.12.3.ebuild,v 1.12 2006/09/05 01:41:56 kumba Exp $

inherit gnome2 eutils

DESCRIPTION="The GNOME panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="doc eds"

RDEPEND=">=gnome-base/gnome-desktop-2.11.92
	>=x11-libs/gtk+-2.7.1
	>=gnome-base/libglade-2.5
	>=gnome-base/libgnome-2.1.1
	>=gnome-base/libgnomeui-2.5.4
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/orbit-2.4
	>=gnome-base/gnome-vfs-2.9.1
	>=x11-libs/libwnck-2.11.91
	>=gnome-base/gconf-2.6.1
	>=gnome-base/gnome-menus-2.11.1
	>=gnome-base/libbonobo-2
	media-libs/libpng
	eds? ( >=gnome-extra/evolution-data-server-1.2 )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.31
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="--disable-scrollkeeper \
		$(use_enable eds)"

	if ! built_with_use dev-libs/libxml2 python; then
		einfo "Please re-emerge dev-libs/libxml2 with the python USE flag set"
		die "libxml2 needs the python use flag set"
	fi
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

