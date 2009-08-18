# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"

#real link is http://handbrake.fr/rotation.php?file=HandBrake-0.9.3.tar.gz
#However, wget does not treat this correctly, and neither does the unpack process.
SRC_URI="http://handbrake.fr/HandBrake-${PV}.tar.gz"

KEYWORDS="x86 amd64"
RESTRICT="fetch"

#qt4 UI is broke, may just need dependancies. This USE flag does nothing.
#Maybe you have better luck ;
IUSE="-gtk -qt4"
RDEPEND="
	gtk? (	>=x11-libs/gtk+-2.8
		>=gnome-extra/gtkhtml-3.14
	)"
DEPEND="sys-libs/zlib
	dev-util/ftjam
	$RDEPEND"


S="${WORKDIR}/HandBrake-${PV}"
GTK="${S}/gtk/src"

pkg_nofetch() {
	einfo "Just download the source code from"
	einfo "${HOMEPAGE}"
	einfo "and save it in ${DISTDIR} "
}

src_unpack() {
   unpack "${A}"
}

src_compile() {

	cd "${S}"

#for local testing purposes; to prevent redownload of contribs.
#	cp -v /tmp/handbrake/HandBrake-0.9.3/contrib/*.tar.gz ./contrib	
	
	einfo "Building HandBrakeCLI."
	make || die "make HandBrakeCLI failed"

	if use gtk ; then
		cd ${S}/gtk
		einfo "Building ghb."
		./autogen.sh || die "gtk autogen.sh failed"
		make || die "make ghb failed"
	fi
	
#	if use qt4 ; then
#		cd ${S}/qt4
#		einfo "Building qtHB."
#		qmake || die "qmake failed"
#		make || die "make qtHB failed"
#	fi
}

src_install() {
	into /usr
	dobin HandBrakeCLI
	dodoc AUTHORS BUILD CREDITS NEWS THANKS TRANSLATIONS
	if use gtk ; then
		dobin ${GTK}/ghb
		
		insinto /usr/share/applications/
		newins ${GTK}/ghb.desktop ghb.desktop
		for res in 64 128; do
        	        insinto /usr/share/icons/hicolor/${res}x${res}/apps/
                	newins ${GTK}/hb-icon${res}.png handbrake.png
        	done
	fi
	
#	if use qt4 ; then
#		dobin ./qt4/qtHB
#	fi
	
}

pkg_postinst() {
	einfo "HandBrakeCLI had been installed."
        if use gtk; then
                einfo "So has ghb, the Handbrake GUI."
                einfo "ghb.desktop has been installed to"
                einfo "/usr/share/applications/"
        fi
}

