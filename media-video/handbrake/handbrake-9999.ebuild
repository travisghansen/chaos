# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"

inherit eutils subversion gnome2-utils

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="doc gtk"
RDEPEND="
	gtk? (	>=x11-libs/gtk+-2.8
		>=gnome-extra/gtkhtml-3.14
	)"
DEPEND="sys-libs/zlib
	>=dev-lang/python-2.4.6
	dev-util/ftjam
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 ) 
	$RDEPEND"

src_configure() {

	local myconf=""

	myconf="${myconf} --force --prefix=/usr"
	! use gtk && myconf="${myconf} $(use_enable gtk)"

	./configure ${myconf} || die "configure failed"

}

src_prepare() {

	einfo "Patching DESTDIR"
	epatch ${FILESDIR}/destdir-fix.patch || die "failed patched DESTDIR into"
	epatch ${FILESDIR}/icon-update.patch || die "failed patching icon-cache"

}

src_compile() {

	cd "${S}/build" || die "cannot find build dir"
	#libdvdread comes up with a system aclocal path when run as root
	#need to patch the check to build correctly and avoid sandbox issues
	make libdvdread.extract
	make libdvdnav.extract
	epatch ${FILESDIR}/libdvdread-aclocal.patch || die "failed patching libdvdread"
	epatch ${FILESDIR}/libdvdnav-aclocal.patch || die "failed patching libdvdnav"

	cd "${S}/build" || die "cannot find build dir"
	make || die "failed compiling ${PN}"

}

src_install() {

	cd "${S}/build" || die "cannot find build dir"
	make DESTDIR=${D} install || die "failed installing ${PN}"

}

pkg_postinst() {

	gnome2_icon_cache_update

}

pkg_postrm() {

	gnome2_icon_cache_update

}
