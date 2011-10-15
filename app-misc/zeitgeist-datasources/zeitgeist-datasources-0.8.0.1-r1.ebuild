# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils versionator

DESCRIPTION="Data providers to the zeitgeist service"
HOMEPAGE="https://launchpad.net/zeitgeist-datasources"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/$(get_version_component_range 1-3)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chromium eog firefox gedit telepathy tomboy totem vim xchat xchat-gnome"

VALA_SLOT="0.12"

DEPEND="app-misc/zeitgeist
	chromium? ( dev-libs/libzeitgeist
			  www-client/chromium
			)
	eog? ( || ( ( <=media-gfx/eog-3[python] ) ( media-gfx/eog ) ) )
	totem?	( media-video/totem
			  dev-libs/libzeitgeist
			)
	firefox? ( || ( ( >=www-client/firefox-4.0 ) ( >=www-client/firefox-bin-4.0 ) )
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
PLUGINS="chromium eog gedit telepathy tomboy totem vim xchat xchat-gnome"

src_prepare() {
	# remove bad 3.6/4.0 ff support
	# https://bugs.launchpad.net/zeitgeist-datasources/+bug/800169
	epatch "${FILESDIR}"/remove-firefox.patch

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
				"firefox" )

					;;
				* )
					emake install DESTDIR="${D}" || die "Failed installing ${PLUGIN} plugin";;
			esac
		fi
	done

	if use firefox ; then
		# see install.rdf to determine the extension id
		insinto \
			"/usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
		doins ${FILESDIR}/xpcom-firefox@zeitgeist-project.com.xpi
	fi

}

pkg_postinst() {
	if use chromium;then
		ewarn "to use the chromium plugin you must open chromium"
		ewarn "then click the wrench -> tools -> extensions"
		ewarn "expand the \"Developer mode\" section"
		ewarn "and click the \"Load unpacked extension...\" button"
		ewarn "then browse to..."
		ewarn "\t/usr/$(get_libdir)/chromium-browser/resources/zeitgeist_plugin/"
		ewarn ""
		ewarn "More info available here"
		ewarn "http://code.google.com/chrome/extensions/packaging.html"
	fi
}

set_plugin_dir() {
	local plugin="$1"

	case "${plugin}" in
		"chromium" )
			PLUGIN_DIR="${S}"/chrome;;
		
		"totem" )
			PLUGIN_DIR="${S}"/totem-libzg;;
	
		"xchat-gnome" )
			PLUGIN_DIR="${S}"/xchat;;

		* )
			PLUGIN_DIR="${S}/${plugin}";;

	esac

}
