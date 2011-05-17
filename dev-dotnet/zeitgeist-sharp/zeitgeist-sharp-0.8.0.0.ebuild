# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit mono versionator

DESCRIPTION="Mono DBus API wrapper for Zeitgeist"
HOMEPAGE="https://launchpad.net/zeitgeist-sharp"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/\
$(get_version_component_range 1-3)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/mono
	app-misc/zeitgeist
	dev-dotnet/dbus-sharp
	dev-dotnet/dbus-sharp-glib
	dev-dotnet/glib-sharp"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "Failed installing"
}
