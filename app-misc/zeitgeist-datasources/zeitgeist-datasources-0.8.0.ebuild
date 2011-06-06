# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils versionator

DESCRIPTION="Data providers to the zeitgeist service"
HOMEPAGE="https://launchpad.net/zeitgeist-datasources"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
#SRC_URI="http://distfiles.one-gear.com/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chromium eog gedit telepathy tomboy totem vim xchat xchat-gnome xulrunner"

VALA_SLOT="0.12"

DEPEND="app-misc/zeitgeist
	chromium? ( dev-libs/libzeitgeist
			  www-client/chromium
			)
	eog? ( media-gfx/eog[python] )
	totem?	( media-video/totem
			  dev-libs/libzeitgeist
			)
	xulrunner? ( >=net-libs/xulrunner-2.0
				 dev-libs/libzeitgeist
			   )
	tomboy? ( app-misc/tomboy
			  dev-dotnet/gtk-sharp
			  dev-dotnet/zeitgeist-sharp
			  dev-python/dbus-python
			)
	telepathy? ( dev-python/telepathy-python
				 dev-python/dbus-python
				 dev-python/pygobject
			   )
	gedit? ( app-editors/gedit )
	vim? ( app-editors/vim[python] )
	dev-lang/vala:${VALA_SLOT}
	xchat? ( net-irc/xchat
			 dev-libs/libzeitgeist
		   )
	xchat-gnome? ( net-irc/xchat-gnome
				   dev-libs/libzeitgeist
				 )"
RDEPEND="${DEPEND}"

# missing bzr emacs geany rhythmbox
# if you're reading his maybe you
# test those and enable
PLUGINS="chromium eog gedit telepathy tomboy totem vim xchat xchat-gnome xulrunner"

src_prepare() {
	epatch "${FILESDIR}"/remove-firefox-36.patch
	sed -i 's:vim72:vimfiles:' vim/Makefile.*
	# not usable please see
	# http://code.google.com/chrome/extensions/trunk/external_extensions.html
	# for more information on system-wide extensions
	SEARCH='$(datadir)/opt/google/chrome/resources'
	REPLACE="/usr/$(get_libdir)/chromium-browser/resources"
	sed -i "s:${SEARCH}:${REPLACE}:" chrome/Makefile.*
	eautoreconf
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
			case "${PLUGIN}" in
				"xchat-gnome" )
					insinto /usr/$(get_libdir)/xchat-gnome/plugins
					doins .libs/zeitgeist_dataprovider.so
					;;
				* )
					emake install DESTDIR="${D}" || die "Failed installing ${PLUGIN} plugin";;
			esac
		fi
	done

}

pkg_postinst() {
	if use chromium;then
		ewarn "to use the chromium plugin you must open chromium"
		ewarn "then click the wrench -> tools -> extensions"
		ewarn "expand the \"Developer mode\" section"
		ewarn "and click the \"Load unpacked extension...\" button"
		ewarn "then browse to..."
		ewarn "\t/usr/$(get_libdir)/chromium-browser/resources/zeitgeist_plugin/"
	fi
}

set_plugin_dir() {
	local plugin="$1"

	case "${plugin}" in
		"chromium" )
			PLUGIN_DIR="${S}"/chrome;;
		
		"totem" )
			PLUGIN_DIR="${S}"/totem-libzg;;
	
		"xulrunner" )
			PLUGIN_DIR="${S}"/firefox-40-libzg;;

		"xchat-gnome" )
			PLUGIN_DIR="${S}"/xchat;;

		* )
			PLUGIN_DIR="${S}/${plugin}";;

	esac

}
