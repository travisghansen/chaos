# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

inherit font

DESCRIPTION="A set of pretty fonts."
HOMEPAGE="http://www.dafont.com/fr/aurulent-sans.font"
SRC_URI="http://distfiles.one-gear.com/distfiles/aurulent_sans.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

FONT_SUFFIX="otf"
S="${WORKDIR}"
FONT_S=${S}

RESTRICT="strip binchecks"
