# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 eutils autotools

DESCRIPTION="Evolution RSS Reader Plugin"
HOMEPAGE="http://gnome.eu.org/index.php/Evolution_RSS_Reader_Plugin"
SRC_URI="http://gnome.eu.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="dbus webkit xulrunner"

RDEPEND=">=mail-client/evolution-2.22
		>=gnome-extra/evolution-data-server-1.2
		xulrunner? ( || ( net-libs/xulrunner www-client/seamonkey
		www-client/mozilla-firefox ) )
		>=gnome-base/gconf-2
		dbus? ( dev-libs/dbus-glib )
		webkit? ( net-libs/webkit-gtk )"

DEPEND="${RDEPEND}
		dev-util/pkgconfig
		sys-devel/automake
		sys-devel/autoconf
		sys-devel/libtool"

pkg_setup() {
		if ! use dbus ; then
			G2CONF="${G2CONF} $(use_enable dbus)"
		fi
}

src_unpack() {
		gnome2_src_unpack

		epatch "${FILESDIR}/${P}-schema.patch"
		
		eautoreconf
}

src_compile() {

		econf $(use_enable xulrunner gecko) \
			$(use_enable webkit) \
			--with-primary-render=webkit \
			--with-gecko=libxul
		
		emake || die "emake failed"	

}

pkg_postinst() {
		einfo "Manually adding schema files that should be added"
		export GNOME2_ECLASS_SCHEMAS="${S}/src/evolution-rss.schemas" 
		gnome2_gconf_install
}

pkg_postrm() {
		einfo "Manually adding schema files that should be removed"
		export GNOME2_ECLASS_SCHEMAS="${S}/src/evolution-rss.schemas" 
		gnome2_gconf_uninstall
}
