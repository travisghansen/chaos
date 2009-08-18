# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

MY_P="${P/handbrake/HandBrake}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"
SRC_URI="http://download.handbrake.fr/handbrake/releases/${MY_P}.tar.gz
http://download.m0k.org/handbrake/contrib/libtheora-1.0.tar.gz
http://download.m0k.org/handbrake/contrib/libdca-r81-strapped.tar.gz
http://download.m0k.org/handbrake/contrib/ffmpeg-r15462.tar.gz
http://download.m0k.org/handbrake/contrib/libmkv-0.6.3.tar.gz
http://download.m0k.org/handbrake/contrib/mpeg4ip-1.3.tar.gz
http://download.m0k.org/handbrake/contrib/mpeg2dec-0.5.1.tar.gz
http://download.m0k.org/handbrake/contrib/libvorbis-aotuv_b5.tar.gz
http://download.m0k.org/handbrake/contrib/a52dec-0.7.4.tar.gz
http://download.m0k.org/handbrake/contrib/faac-1.26.tar.gz
http://download.m0k.org/handbrake/contrib/lame-3.98.tar.gz
http://download.m0k.org/handbrake/contrib/libsamplerate-0.1.4.tar.gz
http://download.m0k.org/handbrake/contrib/bzip2-1.0.5.tar.gz
http://download.m0k.org/handbrake/contrib/libquicktime-0.9.10.tar.gz
http://download.m0k.org/handbrake/contrib/zlib-1.2.3.tar.gz
http://download.m0k.org/handbrake/contrib/faad2-2.6.1.tar.gz
http://download.m0k.org/handbrake/contrib/libogg-1.1.3.tar.gz
http://download.m0k.org/handbrake/contrib/libdvdread-0.9.7.tar.gz
http://download.m0k.org/handbrake/contrib/xvidcore-1.1.3.tar.gz
http://download.m0k.org/handbrake/contrib/x264-r1028-83baa7f.tar.gz
http://download.m0k.org/handbrake/contrib/libmp4v2-r45.tar.gz
"

KEYWORDS="~amd64"

IUSE="gtk"
RDEPEND="gtk? (	>=x11-libs/gtk+-2.8
		>=gnome-extra/gtkhtml-3.14 )"
DEPEND="sys-libs/zlib
	dev-util/ftjam
	${RDEPEND}"

src_unpack() {
	unpack "${MY_P}.tar.gz"
	cp "${DISTDIR}"/*.tar.gz "${S}"/contrib
	cd "${S}"
	epatch "${FILESDIR}/${PV}-no-wget-ktnxbye.patch"
}

src_compile() {
	emake || die "Compilation of HandBrakeCLI failed"
	if use gtk ; then
		cd ${S}/gtk
		eautoreconf
		emake || die "Compilation of ghb failed"
	fi
}

src_install() {
	into /usr
	dobin HandBrakeCLI
	dodoc AUTHORS BUILD CREDITS NEWS THANKS TRANSLATIONS
	if use gtk ; then
		dobin "${S}/gtk/ghb"
		insinto /usr/share/applications/
		doins "${S}/gtk/ghb.desktop"
		for res in 64 128; do
        	        insinto /usr/share/icons/hicolor/${res}x${res}/apps/
                	newins ${GTK}/hb-icon${res}.png handbrake.png
        	done
	fi
}

pkg_postinst() {
	einfo "HandBrakeCLI had been installed."
        if use gtk; then
                einfo "So has ghb, the Handbrake GUI."
                einfo "ghb.desktop has been installed to"
                einfo "/usr/share/applications/"
        fi
}
