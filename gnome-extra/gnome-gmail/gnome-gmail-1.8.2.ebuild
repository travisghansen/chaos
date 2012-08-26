# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2

DESCRIPTION="Gnome Gmail adds support for Gmail to the GNOME desktop"
HOMEPAGE="http://gnome-gmail.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/Version_${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-python/gconf-python
	dev-python/pygobject
	dev-python/gnome-keyring-python"
DEPEND="${RDEPEND}"

