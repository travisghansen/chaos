# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2-utils versionator

VL2=$(get_version_component_range 1-2)
VL3=$(get_version_component_range 1-3)

DESCRIPTION="Activity Log Manager for Zeitgeist"
HOMEPAGE="https://launchpad.net/history-manager"
SRC_URI="http://launchpad.net/history-manager/${VL2}/${VL3}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=gnome-extra/zeitgeist-0.8.0
	x11-libs/gtk+:3
	dev-libs/libgee
	dev-libs/glib"

RDEPEND="${DEPEND}"

src_configure() {
	# http://milky.manishsinha.net/2012/02/07/privacy-and-activity-manager-zeitgeist-release/
	# configure: error: --with-ccpanel was given, but test for
	# libgnome-control-center failed
	#econf --with-ccpanel
	econf
}

src_install() {
	emake install DESTDIR=${D}
	rm -rf "${D}/usr/doc"
	dodoc README NEWS INSTALL ChangeLog COPYING AUTHORS
}
