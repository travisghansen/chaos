# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit versionator eutils

DESCRIPTION="Primary data extension for Zeitgeist in GNOME"
HOMEPAGE="https://launchpad.net/zeitgeist-datahub"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="vala"

VALA_SLOT="0.10"

DEPEND="x11-libs/gtk+
	dev-libs/libzeitgeist
	vala? ( dev-lang/vala:${VALA_SLOT} )"
RDEPEND="${DEPEND}"

src_configure() {
	local myconf
	if use vala;then
		myconf="VALAC=$(type -p valac-${VALA_SLOT})"
	fi
	econf ${myconf}
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"
}
