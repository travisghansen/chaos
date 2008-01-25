# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/ximian-artwork/ximian-artwork-0.2.32.1.ebuild,v 1.3 2005/09/07 13:42:37 gustavoz Exp $

inherit eutils autotools 

# bash magic to extract last 2 versions as XIMIAN_V,
# third last version as RPM_V and the rest as MY_PV

MY_P="ximian-artwork"

DESCRIPTION="Ximian Desktop's GTK, Galeon, GDM, Metacity, Nautilus, XMMS themes, icons and cursors."
HOMEPAGE="http://www.novell.com/products/desktop/"
SRC_URI="http://ultra.hivalley.com/data/${MY_P}-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 sparc ~amd64 ~ppc"
IUSE="xmms"

DEPEND="sys-devel/autoconf
	sys-devel/automake"

RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}-${PV}

src_unpack() {

	unpack ${A}
	cd ${S}

#	epatch ${FILESDIR}/${P}-disable_industrial_engine.patch
	epatch ${FILESDIR}/remove-gtk1.patch
	epatch ${FILESDIR}/remove-gtk1-1.patch
	epatch ${FILESDIR}/remove-others.patch
	epatch ${FILESDIR}/more.patch
	epatch ${FILESDIR}/more1.patch


}

src_compile() {
	aclocal && autoconf && automake || die
	libtoolize --copy --force

#	eautoreconf

	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	# Removing trademarks
#	patch ${D}/usr/share/gdm/themes/industrial/industrial.xml < ${FILESDIR}/${PN}-0.2.26-gdm.patch || die "patch failed"
#	rm -f ${D}/usr/share/gdm/themes/industrial/xd2logo.png
#	rm -rf ${D}/usr/share/pixmaps/ximian
#	rm -f ${D}/usr/share/pixmaps/ximian-desktop-stripe.png

	# Set up X11 implementation
	#X11_IMPLEM_P="$(best_version virtual/x11)"
	#X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
	#X11_IMPLEM="${X11_IMPLEM##*\/}"
#	X11_IMPLEM="xorg-x11"
#	einfo "X11 implementation is ${X11_IMPLEM}."

	# Moving cursors
#	dodir /usr/share/cursors/${X11_IMPLEM}/Industrial
#	mv ${D}/usr/share/icons/Industrial/cursors ${D}/usr/share/cursors/${X11_IMPLEM}/Industrial

	# remove xmms skin if unneeded
#	use xmms || rm -rf ${D}/usr/share/xmms

#	cd ${S}
#	dodoc COPYING ChangeLog
}
