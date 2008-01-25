# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono eutils gnome2

BUILDDATE="20061231-0101"

DESCRIPTION="Novell iFolder"
HOMEPAGE="http://www.ifolder.com/"
SRC_URI="http://distfiles.one-gear.com/distfiles/${PN}${PV:0:1}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
RESTRICT="mirror"

IUSE=""
DEPEND=">=dev-lang/mono-1.0
	>=dev-dotnet/gconf-sharp-2.0
	>=dev-dotnet/gnome-sharp-2.0
	>=dev-dotnet/gtk-sharp-2.0
	>=net-misc/simias-1.0
	>=gnome-base/eel-2.12"

#S="${WORKDIR}/ifolder${PV:0:1}-${PV}"
S="${WORKDIR}/${PN}"


src_unpack() {

	gnome2_src_unpack
	#Change .desktop file to place icon in Internet group instead of Programming
	epatch ${FILESDIR}/desktop-file-categories.patch  || die "Error applying patch"
#	epatch ${FILESDIR}/webdir-prefix.patch  || die "Error applying patch"
#	epatch ${FILESDIR}/configure-help.patch  || die "Error applying patch"
#	epatch ${FILESDIR}/tray-icon.patch  || die "Error applying patch"
	

}

src_compile() {

	local myconf
	./autogen.sh
	gnome2_src_configure
	#econf
	emake

}
