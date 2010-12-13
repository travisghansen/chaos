# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-murrine/gtk-engines-murrine-0.90.3-r1.ebuild,v 1.7 2010/02/14 06:23:53 nirbheek Exp $

EAPI="2"

inherit cmake-utils

MY_PN="oxygen-gtk"
DESCRIPTION="KDE Oxygen clone for gtk+"

HOMEPAGE="http://hugo-kde.blogspot.com/2010/11/oxygen-gtk.html"
SRC_URI="http://download.kde.org/download.php?url=stable/oxygen-gtk/${PV}/src/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1
	sys-devel/gettext
	dev-util/pkgconfig
	dev-util/cmake"

S="${WORKDIR}/${MY_PN}-${PV}"
DOCS="AUTHORS COPYING README INSTALL"
