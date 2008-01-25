# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/metacity/metacity-2.12.3.ebuild,v 1.11 2006/09/06 05:41:40 kumba Exp $

inherit eutils gnome2

DESCRIPTION="Gnome default windowmanager"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="xinerama"

# not parallel-safe; see bug #14405
MAKEOPTS="${MAKEOPTS} -j1"

RDEPEND=" >=x11-libs/gtk+-2.6
	>=x11-libs/pango-1.2
	>=gnome-base/gconf-2
	>=dev-libs/glib-2.6
	>=x11-libs/startup-notification-0.7
	!x11-misc/expocity"

# Needed for compositor
#			x11-libs/libXdamage
#			x11-libs/libXcomposite
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28"

USE_DESTDIR="1"
DOCS="AUTHORS ChangeLog HACKING NEWS README *.txt doc/*.txt"


pkg_setup() {
	# Compositor is too unreliable
	G2CONF="$(use_enable xinerama) \
		--disable-compositor"
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Fix the logout shortcut problems, by moving the keybindings
	# into here, from control-center, fixes bug #52034
	epatch "${FILESDIR}"/${PN}-2-logout.patch
}

pkg_postinst() {
	gnome2_pkg_postinst

	einfo "Metacity & Xorg X11 with composite enabled may cause unwanted"
	einfo "border effects"
}
