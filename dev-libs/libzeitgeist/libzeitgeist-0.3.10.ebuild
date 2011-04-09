# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit versionator eutils

DESCRIPTION="Zeitgeist is a service which logs the users's activities and events"
HOMEPAGE="https://launchpad.net/libzeitgeist"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-libs/raptor
	dev-python/rdflib
	dev-python/pyxdg
	dev-python/dbus-python
	dev-python/pygobject
	dev-libs/glib:2"

RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:doc/libzeitgeist:doc/${PF}:" \
		Makefile.am || die
}

src_configure() {
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"
}
