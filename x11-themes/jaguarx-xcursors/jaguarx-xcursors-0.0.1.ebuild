# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/jimmac-xcursors/jimmac-xcursors-0.0.1.ebuild,v 1.11 2006/01/31 14:57:12 josejx Exp $

MY_P="14775-jaguarx.tar.bz2"
DESCRIPTION="A high quality set of Xfree 4.3.0 animated mouse cursors"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=14775"
SRC_URI="http://ultra.hivalley.com/data/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=""

S=${WORKDIR}

src_install() {
	#X11_IMPLEM_P="$(best_version virtual/x11)"
	#X11_IMPLEM="${X11_IMPLEM_P%-[0-9]*}"
	#X11_IMPLEM="${X11_IMPLEM##*\/}"
	X11_IMPLEM="xorg-x11"
	einfo "X11 implementation is ${X11_IMPLEM}."

	dodir /usr/share/cursors/${X11_IMPLEM}/jaguarx/cursors/
	cp -d  jaguarx/cursors/* \
		${D}/usr/share/cursors/${X11_IMPLEM}/jaguarx/cursors/ || die
}

pkg_postinst() {
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line:"
	einfo "Xcursor.theme: Jimmac"
	einfo ""
	einfo "Also, you can change the size by adding a line like:"
	einfo "Xcursor.size: 48"
	einfo ""
	einfo "To globally use this set of mouse cursors edit the file:"
	einfo "	  /etc/env.d/99xcursors"
	einfo "and change add the line:"
	einfo "	  XCURSORS_THEME="jaguarx""
	einfo "Note this will be overruled by a user's ~/.Xdefaults file."
	einfo ""
	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your XF86Config:"
	ewarn "Option \"HWCursor\" \"false\""
}
