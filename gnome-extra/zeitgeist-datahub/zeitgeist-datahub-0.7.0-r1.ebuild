# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

DESCRIPTION="Provides passive plugins to insert events into zeitgeist"
HOMEPAGE="https://launchpad.net/zeitgeist-datahub"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

VALA_SLOT="0.12"

CDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2
	dev-libs/libzeitgeist
	dev-lang/vala:${VALA_SLOT}"

RDEPEND="${CDEPEND}
	app-misc/zeitgeist"

RDEPEND="${CDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf VALAC=$(type -P valac-${VALA_SLOT})
}
