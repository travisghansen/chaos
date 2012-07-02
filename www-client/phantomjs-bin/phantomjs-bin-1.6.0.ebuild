# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

MY_P="phantomjs"

DESCRIPTION="headless WebKit with JavaScript API"
HOMEPAGE="http://www.phantomjs.org/"
SRC_URI="x86? ( http://${MY_P}.googlecode.com/files/${MY_P}-${PV}-linux-i686-dynamic.tar.bz2 )
		 amd64? ( http://${MY_P}.googlecode.com/files/${MY_P}-${PV}-linux-x86_64-dynamic.tar.bz2  )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="examples python"

RDEPEND="!www-client/phantomjs
	>=media-libs/freetype-2.4.4
	>=media-libs/fontconfig-2.8.0-r1
	>=dev-libs/expat-2.0.1-r3"
DEPEND="${RDEPEND}"
RESTRICT="mirror"
S="${A:0:-8}"

src_install() {
	dodir "/opt/${MY_P}"
	cp -R "${S}"/* "${D}/opt/${MY_P}"

	chown -R root:root "${D}/opt/${MY_P}"
	dosym /opt/${MY_P}/bin/phantomjs /usr/bin/phantomjs
}
