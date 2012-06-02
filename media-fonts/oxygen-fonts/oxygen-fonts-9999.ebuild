# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://anongit.kde.org/oxygen-fonts"
inherit git-2 font

DESCRIPTION="A Font for the KDE Desktop"
HOMEPAGE="https://projects.kde.org/"
SRC_URI=""

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#FONT_SUFFIX="ttf"
#RESTRICT="strip binchecks"

src_install() {
	cd ${S}/version-0.2
	insinto /usr/share/fonts/oxygen-fonts/
	doins Monospace/* Oxygen-Bold/* Oxygen-Regular/*
	font_src_install
}
