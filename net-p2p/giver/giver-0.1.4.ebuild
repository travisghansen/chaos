# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit mono

DESCRIPTION="File Sharing Made Easy"
HOMEPAGE=""
SRC_URI="http://green.hivalley.com/data/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		dev-dotnet/notify-sharp
		dev-dotnet/ndesk-dbus
		net-dns/avahi
		dev-dotnet/gtk-sharp
		dev-dotnet/gnome-sharp"


src_install(){

	make DESTDIR=${D} install

}
