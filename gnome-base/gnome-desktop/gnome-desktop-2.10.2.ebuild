# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-desktop/gnome-desktop-2.10.2.ebuild,v 1.12 2006/09/05 01:55:49 kumba Exp $

inherit gnome2

DESCRIPTION="Libraries for the gnome desktop that is not part of the UI"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="static"

RDEPEND=">=x11-libs/gtk+-2.1.2
	>=dev-libs/glib-2.6
	>=gnome-base/libgnomeui-2.1
	>=gnome-base/libgnomecanvas-2
	>=gnome-base/gnome-vfs-2
	>=x11-libs/startup-notification-0.5
	!gnome-base/gnome-core"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

USE_DESTDIR="1"
G2CONF="$G2CONF --with-gnome-distributor=Gentoo $(use_enable static)"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fix bug 16853 by building gnome-about with IEEE to prevent
	# floating point exceptions on alpha
	if use alpha; then
		sed -i '/^CFLAGS/s/$/ -mieee/' ${S}/gnome-about/Makefile.in \
		|| die "sed failed (2)"
	fi
}
