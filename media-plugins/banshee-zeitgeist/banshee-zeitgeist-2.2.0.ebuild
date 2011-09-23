# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/banshee-community-extensions/banshee-community-extensions-1.8.0.ebuild,v 1.4 2010/11/17 20:57:57 hwoarang Exp $

EAPI=3

inherit base mono

MY_P="banshee-community-extensions"
DESCRIPTION="Community-developed plugins for the Banshee media player"
HOMEPAGE="http://banshee-project.org/"
SRC_URI="http://download.banshee-project.org/${MY_P}/${PV}/${MY_P}-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/mono-2.0
	>=media-sound/banshee-1.7.4[web]
	dev-dotnet/zeitgeist-sharp"
RDEPEND="${DEPEND}"

S="${MY_P}-${PV}"

src_configure() {

	cd "${S}"

	local myconf="--enable-gnome
        --disable-static
        --enable-release
        --disable-maintainer-mode
        --with-gconf-schema-file-dir=/etc/gconf/schemas
        --with-vendor-build-id=Gentoo/${PN}/${PVR}
        --disable-scrollkeeper
        --disable-clutterflow --disable-appindicator --disable-openvp
        --enable-zeitgeistdataprovider
        --enable-ampache --enable-karaoke --enable-jamendo
        --enable-randombylastfm --enable-albumartwriter
        --enable-duplicatesongdetector"

	econf ${myconf}

}

src_install() {
	cd "${S}/src/ZeitgeistDataprovider"
	base_src_install
}
