# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils versionator

DESCRIPTION="Googsystray is a system tray app for Google Web Apps"
HOMEPAGE="http://googsystray.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/pygtk"
RDEPEND="${DEPEND}"

