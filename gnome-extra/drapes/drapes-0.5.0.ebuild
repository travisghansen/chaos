# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 mono

DESCRIPTION="Desktop drapes is a wallpaper manager application for the gnome desktop."
HOMEPAGE="http://drapes.mindtouchsoftware.com/"
SRC_URI="http://drapes.mindtouchsoftware.com/release/${PV:0:3}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/mono
	>=dev-dotnet/gtk-sharp-2.0
	>=dev-dotnet/gnome-sharp-2.0"
RDEPEND="${DEPEND}"
