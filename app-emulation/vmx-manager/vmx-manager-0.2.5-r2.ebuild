# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono gnome2

DESCRIPTION="Create, configure, and manage VMware virtual machines"
HOMEPAGE="http://www.snorp.net"
SRC_URI="http://ubersekret.com/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-emulation/vmware-player
	dev-lang/mono
	sys-apps/dbus
	sys-apps/hal
	>=dev-dotnet/gnome-sharp-2.0
	>=dev-dotnet/gnomevfs-sharp-2.0
	>=dev-dotnet/glade-sharp-2.0
	>=dev-dotnet/gtk-sharp-2.0"

RDEPEND="${DEPEND}"

src_compile() {
	gnome2_src_configure
	emake DESTDIR="${D}"
}
