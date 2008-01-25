# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit gnome2 mono

DESCRIPTION="LAT stands for LDAP Administration Tool. The tool allows you to browse LDAP-based directories and add/edit/delete entries contained within."
HOMEPAGE="http://dev.mmgsecurity.com/projects/lat"
SRC_URI="http://dev.mmgsecurity.com/downloads/${PN}/1.1/${P}.tar.gz"
LICENSE="GPL-2"
IUSE="avahi"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND=">=dev-lang/mono-1.1.13
	=dev-dotnet/gtk-sharp-2.8*
	=dev-dotnet/gnome-sharp-2.8*
	=dev-dotnet/glade-sharp-2.8*
	=dev-dotnet/gconf-sharp-2.8*
	=gnome-base/gnome-keyring-0.4*
	sys-apps/dbus
	avahi? ( net-dns/avahi )"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"

pkg_setup() {
	if use avahi ; then
		built_with_use -a net-dns/avahi mono || die \
		"${PN} requires avahi build with mono support. Please, reemerge avahi with USE=\"mono\""
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	autoreconf || die
}

src_compile () {
	econf ${myconf} \
		$(use_enable avahi) || die "./configure failed"
	LANG=C emake -j1 || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ${DOCS}
}
