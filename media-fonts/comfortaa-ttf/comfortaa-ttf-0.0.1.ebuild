# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

inherit font

DESCRIPTION="Comfortaa is a bran new, modern style, true type font"
HOMEPAGE="http://aajohan.deviantart.com/art/Comfortaa-font-105395949"
SRC_URI="http://distfiles.one-gear.com/distfiles/Comfortaa___font_by_aajohan.zip"

LICENSE="CC"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

FONT_SUFFIX="ttf"
S="${WORKDIR}/Comfortaa"
FONT_S=${S}

RESTRICT="strip binchecks"
