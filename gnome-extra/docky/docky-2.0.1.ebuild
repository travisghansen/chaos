# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit versionator

DESCRIPTION="A GNOME dock application that makes opening common applications
quicker."
HOMEPAGE="http://www.go-docky.com/"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/mono-2.4
	dev-dotnet/wnck-sharp
	dev-dotnet/notify-sharp
	dev-dotnet/gtk-sharp
	dev-dotnet/gnome-sharp
	dev-dotnet/gnome-keyring-sharp
	dev-dotnet/gnome-desktop-sharp
	dev-dotnet/gnomevfs-sharp
	dev-dotnet/glib-sharp
	dev-dotnet/glade-sharp
	dev-dotnet/gconf-sharp
	dev-dotnet/rsvg-sharp
	dev-dotnet/dbus-sharp
	dev-dotnet/dbus-glib-sharp
	dev-dotnet/mono-addins
	x11-libs/gtk+
	dev-libs/glib"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"
}

