# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/banshee-community-extensions/banshee-community-extensions-1.8.0.ebuild,v 1.4 2010/11/17 20:57:57 hwoarang Exp $

EAPI=3

inherit base mono

DESCRIPTION="Community-developed plugins for the Banshee media player"
HOMEPAGE="http://banshee-project.org/"
SRC_URI="http://distfiles.one-gear.com/distfiles/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/mono-2.0
	>=media-sound/banshee-1.7.4[web]
	dev-dotnet/zeitgeist-sharp"
RDEPEND="${DEPEND}"

S="banshee-community-extensions-${PV}"

src_configure() {

	cd "${S}"

	econf \
	--disable-alarmclock --disable-ampache --disable-appindicator \
	--disable-awn --disable-clutterflow --disable-coverwallpaper \
	--disable-jamendo --disable-lastfmfingerprint --disable-lcd --disable-lirc \
	--disable-liveradio --disable-lyrics --disable-magnatune --disable-mirage \
	--disable-openvp --disable-radiostationfetcher --disable-randombylastfm \
	--disable-soundmenu --disable-streamrecorder --disable-telepathy \
	--disable-ubuntuonemusicstore

}

src_install() {
	cd "${S}/src/ZeitgeistDataprovider"
	base_src_install
}
