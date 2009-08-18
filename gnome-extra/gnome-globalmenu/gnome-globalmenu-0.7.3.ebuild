# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit autotools gnome2 eutils

DESCRIPTION="Global Menu Bar for GNOME"
HOMEPAGE="http://code.google.com/p/gnome2-globalmenu/"
SRC_URI="http://gnome2-globalmenu.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-libs/glib-2.18.4
		>=gnome-base/gnome-panel-2.24.0
		>=x11-libs/gtk+-2.14.0
		>=x11-libs/libwnck-2.24.0
		>=dev-lang/vala-0.5.5"

src_unpack(){

	gnome2_src_unpack
	
#	epatch ${FILESDIR}/control-center-apps.patch;
#	epatch ${FILESDIR}/control-center-list.patch;
#	epatch ${FILESDIR}/slab-schema.patch
#	epatch ${FILESDIR}/file-location-lookup.patch
#	epatch ${FILESDIR}/${PN}-doc_check.patch
#	epatch ${FILESDIR}/package-lookup.patch
#	epatch ${FILESDIR}/upgrade-uninstall.patch
#	cp ${FILESDIR}/gnome-main-menu-application-install.desktop.in ${S}/main-menu/etc/
#	sed -i -e 's/main-menu-rug/gnome-main-menu-application-install/g' \
#	${S}/main-menu/etc/Makefile.* || die "Error modifying Makefiles"



}

src_compile(){

#	eautoreconf
#	econf
#	./autogen.sh --prefix=/usr
	econf
	make DESTDIR=${D}
}
