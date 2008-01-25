# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils mono gnome2

DESCRIPTION="Diva is a project to build an easy to use, scalable, open-source
video editing software for the Gnome desktop."
HOMEPAGE="http://www.diva-project.org/"
SRC_URI="http://files.diva-project.org/releases/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="a52 flac dv ieee1394 jpeg lame png mad encode"

DEPEND=">=dev-util/scons-0.96.1"

RDEPEND="a52? ( >=media-plugins/gst-plugins-a52dec-0.10 )
		flac? ( >=media-plugins/gst-plugins-flac-0.10 )
		dv? ( >=media-plugins/gst-plugins-dv-0.10 )
		jpeg? ( >=media-plugins/gst-plugins-jpeg-0.10 )
		lame? ( >=media-plugins/gst-plugins-lame-0.10 )
        png? ( >=media-plugins/gst-plugins-libpng-0.10 )
        mad? ( >=media-plugins/gst-plugins-mad-0.10 )
        encode? ( >=media-plugins/gst-plugins-ffmpeg-0.10 )		
		>=media-plugins/gst-plugins-theora-0.10	
		>=media-plugins/gst-plugins-ogg-0.10
		>=media-libs/gstreamer-0.10.4
		>=media-libs/gst-plugins-base-0.10.4
		>=media-libs/gst-plugins-good-0.10.3
		>=media-plugins/gst-plugins-ffmpeg-0.10
		>=x11-libs/gtk+-2.8.0
		>=x11-libs/cairo-1.0.0
		>=dev-lang/mono-1.1
		>=dev-dotnet/gtk-sharp-2.8.0
		>=dev-dotnet/gconf-sharp-2.8.0
		>=dev-dotnet/gnome-sharp-2.8.0"

src_compile() {

	addwrite /usr/$(get_libdir)
	addwrite /usr/include
	
	mkdir ${D} || die "Error creating image dir"
	scons PREFIX=/usr DESTDIR=${D} || die "Error compiling ${PN}"

}


src_install() {

	addwrite /usr/$(get_libdir)
	addwrite /usr/include

	scons DESTDIR=${D} PREFIX=/usr install || die "Error installing ${PN}"

}

pkg_postinst() {

	einfo "${PN} currently only supports dv and wave files"
	einfo "If build with the jpeg and png USE flags you"
	einfo "should be able to import those picture formats"

}
