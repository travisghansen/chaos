# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-1.4.2-r2.ebuild,v 1.15 2006/09/05 01:41:56 kumba Exp $

inherit libtool

S=${WORKDIR}/gnome-core-${PV}
DESCRIPTION="Split out panel from gnome-core"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/gnome-core/1.4/gnome-core-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.4"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~sparc x86"
IUSE="kde nls"

RDEPEND="=gnome-base/control-center-1.4*
	<gnome-base/libglade-0.99.0
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=media-libs/gdk-pixbuf-0.16.0-r1"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.2
	=sys-devel/automake-1.4*
	sys-devel/autoconf
	nls? ( sys-devel/gettext
	>=dev-util/intltool-0.11 )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# libpng-1.2.5 fix
	cp configure.in configure.in.old
	sed -e "s:-lz:\`libpng-config --libs\`:" configure.in.old \
		> configure.in

	# Libtoolize
	elibtoolize
	aclocal -I macros
	WANT_AUTOMAKE=1.4 automake --add-missing
	autoconf
}

src_compile() {
	local myconf=""
	local myldflags=""

	use nls || myconf="${myconf} --disable-nls"

	if use kde
	then
		myconf="${myconf} --with-kde-datadir=/usr/share"
	fi

	# Fix build against gdk-pixbuf-0.12 and later
	CFLAGS="${CFLAGS} `gdk-pixbuf-config --cflags`"

	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --mandir=/usr/share/man \
		    --sysconfdir=/etc \
		    --localstatedir=/var/lib \
		    ${myconf} || die

	cd panel
	cp gnome-panel-screenshot.c gnome-panel-screenshot.c.orig
	cat gnome-panel-screenshot.c.orig | \
		sed 's:\(^#include <errno.h>\):\1\n#include <locale.h>:' \
		> gnome-panel-screenshot.c

	cd ${S}
	make -C panel
}

src_install() {
	make -C panel \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die
	dodoc AUTHORS COPYING* ChangeLog README NEWS
	rm -f  ${D}/usr/bin/gnome-panel-screenshot
	rm -f  ${D}/usr/share/gnome/panel/gnome-panel-screenshot.glade
}

