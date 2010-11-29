# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git autotools
#kde4-base mozconfig-3

DESCRIPTION="SFLphone is a robust standards-compliant enterprise softphone, for desktop and embedded systems."
HOMEPAGE="http://www.sflphone.org/"
SRC_URI=""
EGIT_REPO_URI="http://git.sflphone.org/sflphone.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome gsm speex iax networkmanager debug python"
#TODO:kde doc

DEPEND="net-libs/pjsip
	media-sound/pulseaudio
	media-libs/libsamplerate
	net-libs/libzrtpcpp
	net-libs/ccrtp
	dev-cpp/commoncpp2
	sys-apps/dbus
	dev-libs/openssl
	dev-libs/expat
	media-libs/alsa-lib
	media-libs/celt
	virtual/libstdc++
	dev-libs/libpcre
	gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	networkmanager? ( net-misc/networkmanager )
	iax? ( net-libs/iax )
	gnome? ( dev-libs/check 
		dev-libs/log4c
		dev-libs/glib
		x11-libs/libnotify
		gnome-extra/evolution-data-server
		dev-libs/libxml2
		net-libs/libsoup
		gnome-base/libgnomeui
		x11-libs/libICE
		x11-libs/libSM 
		gnome-base/libbonoboui
		gnome-base/gnome-vfs
		gnome-base/libgnomecanvas
		gnome-base/libgnome
		dev-libs/popt 
		gnome-base/libbonobo
		gnome-base/orbit
		media-libs/libart_lgpl
		x11-libs/gtk+
		dev-libs/atk
		x11-libs/pango
		x11-libs/cairo 
		media-libs/freetype
		media-libs/fontconfig
		gnome-base/gconf )"
#	kde? ( kde-base/kdepimlibs dev-util/cmake )" 
#	doc? ( dev-libs/libxslt dev-python/cheetah )
RDEPEND="${DEPEND}"

src_prepare() {
	if ! use gnome && ! use python;then #&& ! use kde
		ewarn
		ewarn "You need at least the python command line client to get"
		ewarn "a sflphoned client."
		ewarn
	fi
	cd sflphone-common
	./autogen.sh || die "autogen failed"
	sed -i -e 's/-$(target)//' \
		$(find . -name Makefile.in) || die "sed failed."

	if use gnome;then
		cd ../sflphone-client-gnome
		./autogen.sh || die "autogen failed"
	fi
}

src_configure() {
	cd sflphone-common
	econf --disable-dependency-tracking \
		$(use_with debug) \
		$(use_with gsm) \
		$(use_with speex) \
		$(use_with iax iax2) \
		$(use_with networkmanager) || die "econf failed."
	
	#remove dependency to the shipped pjsip
	sed -i -e '/^\t\t\t-L/ d' src/Makefile || die "sed failed."
	#TODO: remove includes to shipped pjsip
	#TODO: remove shipped dbus-c++ use system one (see #220767)
	#TODO: remove shipped utilspp (from curlpp), use system one, see #55185

	if use gnome;then
		cd ../sflphone-client-gnome
		econf || die "econf failed."
	fi

#	if use kde;then
#		cd ../sflphone-client-kde
#		kde4-base_src_configure
#	fi
}

src_compile() {
	cd sflphone-common
	emake || die "emake failed."

	if use gnome;then
		cd ../sflphone-client-gnome
		emake || die "emake failed."
	fi

#	if use kde;then
#		cd ../sflphone-client-kde
#		kde4-base_src_compile
#	fi
}

src_install() {
	cd sflphone-common
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc test/sflphonedrc-sample
	#TODO: doc
	#if use doc; then
	#	dodoc COPYING README README.gentoo ChangeLog
	#fi
	cd ../tools
	dobin sflphone-callto mozilla-telify-sflphone/sflphone-handler
	#xpi_install mozilla-telify-sflphone/telify-0.4.7.3-fx.xpi

	if use gnome;then
		cd ../sflphone-client-gnome
		emake DESTDIR="${D}" install || die "emake install failed"
	fi

#	if use kde;then
#		cd ../sflphone-client-kde
#		kde4-base_src_install
#	fi

	if use python;then
		cd ../tools/pysflphone
		mv pysflphone.py pysflphone
		dobin pysflphone sflphonectrlsimple.py Errors.py pysflphone_testdbus.py
	fi
}

pkg_postinst() {
	elog
	elog "You need to restart dbus, if you want to access"
	elog "sflphoned through dbus."
	elog
	elog
	elog "If you use the command line client extract"
	elog "/usr/share/doc/${PF}/${PN}drc-sample to"
	elog "~/.config/${PN}/${PN}drc for example config."
	elog
	elog
	elog "For calls out of your browser have a look in sflphone-callto"
	elog "and sflphone-handler. You should consider to install"
	elog "the \"Telify\" Firefox addon."
	elog
	if use gnome;then
		elog
		elog "sflphone-client-gnome: To manage your contacts you need"
		elog "mail-client/evolution or access to an evolution-data-server"
		elog "connected backend."
		elog
	fi
}
