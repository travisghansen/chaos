# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils versionator

DESCRIPTION="Data providers to the zeitgeist service"
HOMEPAGE="https://launchpad.net/zeitgeist-dataproviders"
#SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
SRC_URI="http://distfiles.one-gear.com/distfiles/zeitgeist-dataproviders-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eog gedit telepathy tomboy totem vim xchat xulrunner"

VALA_SLOT="0.12"

DEPEND="app-misc/zeitgeist
	eog? ( media-gfx/eog[python] )
	totem?	( media-video/totem
			  dev-libs/libzeitgeist
			)
	xulrunner? ( >=net-libs/xulrunner-2.0
				 dev-libs/libzeitgeist
			   )
	tomboy? ( 	app-misc/tomboy
				dev-dotnet/gtk-sharp
				dev-dotnet/zeitgeist-sharp
			)
	gedit? ( app-editors/gedit )
	vim? ( app-editors/vim[python] )
	dev-lang/vala:${VALA_SLOT}"
RDEPEND="${DEPEND}"

PLUGINS="eog gedit telepathy tomboy totem vim xchat xulrunner"

src_prepare() {
	eautoreconf
	epatch "${FILESDIR}"/ffpatch.patch
	epatch "${FILESDIR}"/ff4.patch
	epatch "${FILESDIR}"/ff4-2.patch
	sed -i 's:vim72:vimfiles:' vim/Makefile.*
	# not usable please see
	# http://code.google.com/chrome/extensions/trunk/external_extensions.html
	# for more information on system-wide extensions
	SEARCH='$(datadir)/opt/google/chrome/resources'
	REPLACE="/usr/$(get_libdir)/chromium-browser/resources"
	sed -i "s:${SEARCH}:${REPLACE}:" chrome/Makefile.*
}

src_configure() {
	econf VALAC=$(type -p valac-${VALA_SLOT})
}

src_compile() {

	for PLUGIN in ${PLUGINS};do
		if use ${PLUGIN};then
			set_plugin_dir "${PLUGIN}";
			cd "${PLUGIN_DIR}" || die "Failed to cd to ${PLUGIN_DIR}"
			emake || die "Failed compiling ${PLUGIN} plugin"
		fi
	done

}

src_install() {

	for PLUGIN in ${PLUGINS};do
		if use ${PLUGIN};then
			set_plugin_dir "${PLUGIN}";
			cd "${PLUGIN_DIR}" || die "Failed to cd to ${PLUGIN_DIR}"
			emake install DESTDIR="${D}" || die "Failed installing ${PLUGIN} plugin"
		fi
	done

}

pkg_postinst() {
	ewarn "Information is also availabe for google chromium available here"
	ewarn "http://code.google.com/p/webupd8/downloads/list"
	ewarn "http://www.webupd8.org/2010/12/zeitgeist-extension-for-chrome-to-use.html"
}

set_plugin_dir() {
	local plugin="$1"

	case "${plugin}" in
		"totem" )
			PLUGIN_DIR="${S}"/totem-libzg;;
	
		"xulrunner" )
			PLUGIN_DIR="${S}"/firefox-libzg;;

		* )
			PLUGIN_DIR="${S}/${plugin}";;

	esac

}
