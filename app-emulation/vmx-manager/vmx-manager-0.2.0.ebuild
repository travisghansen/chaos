# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono gnome2

DESCRIPTION="manager for creating vmx images"
HOMEPAGE="http://www.snorp.net"
SRC_URI="http://ultra.hivalley.com/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-emulation/vmware-player
		dev-lang/mono
		dev-dotnet/gtk-sharp"
RDEPEND=""

src_compile(){

	gnome2_src_configure
	make DESTDIR=${D}

}
