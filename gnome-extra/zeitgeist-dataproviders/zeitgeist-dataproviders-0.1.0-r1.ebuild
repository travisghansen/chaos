# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils versionator

DESCRIPTION="Zeitgeist is a service which logs the users's activities and events"
HOMEPAGE="https://launchpad.net/zeitgeist-dataproviders"
#SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
SRC_URI="http://distfiles.one-gear.com/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="eog gedit tomboy totem vim xulrunner"

DEPEND="gnome-extra/zeitgeist
	eog? ( media-gfx/eog[python] )
	totem?	( media-video/totem
			  dev-libs/libzeitgeist
			)
	xulrunner? ( net-libs/xulrunner
				 dev-libs/libzeitgeist
			   )
	tomboy? ( 	app-misc/tomboy
				dev-dotnet/gtk-sharp
				dev-dotnet/zeitgeist-sharp
			)
	gedit? ( app-editors/gedit )
	vim? ( app-editors/vim[python] )"
RDEPEND="${DEPEND}"

PLUGINS="eog gedit tomboy totem vim xulrunner"

src_prepare() {
	sed -i 's:vim72:vimfiles:' vim/Makefile.*
}

src_configure() {
	VALAC=/usr/bin/valac-0.10 econf
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

set_plugin_dir() {
	local plugin="$1"

	case "${plugin}" in
		"totem" )
			PLUGIN_DIR="${S}/totem-libzg";;
	
		"xulrunner" )
			PLUGIN_DIR="${S}/firefox-libzg";;

		* )
			PLUGIN_DIR="${S}/${plugin}";;

	esac

}
