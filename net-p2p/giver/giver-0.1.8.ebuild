# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit mono

DESCRIPTION="File Sharing Made Easy"
HOMEPAGE=""
SRC_URI="http://giver.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		dev-dotnet/notify-sharp
		dev-dotnet/dbus-sharp
		dev-dotnet/dbus-glib-sharp
		net-dns/avahi
		dev-dotnet/gtk-sharp
		dev-dotnet/gnome-sharp"


src_install(){

	make DESTDIR=${D} install

}
