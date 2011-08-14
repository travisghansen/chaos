# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils versionator

DESCRIPTION="GNOME flickr manager"
HOMEPAGE="https://live.gnome.org/Frogr"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="gtk"

DEPEND="dev-libs/glib
	media-libs/libexif
	dev-libs/libxml2
	dev-perl/XML-Parser
	|| ( net-libs/libsoup net-libs/libsoup-gnome )
	x11-libs/gtk+:2"

RDEPEND="${DEPEND}"

src_configure(){
	econf --with-gtk=2.0
}

src_install(){
	emake install DESTDIR="${D}"
}
