# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono

DESCRIPTION="An audio stream ripper for Last.fm."
HOMEPAGE="http://code.google.com/p/thelastripper/"
SRC_URI="http://thelastripper.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/mono
		>=dev-dotnet/gtk-sharp-2
		>=dev-dotnet/glade-sharp-2
		>=dev-dotnet/rsvg-sharp-2"
RDEPEND=""


src_install(){

	make DESTDIR=${D} install

}

