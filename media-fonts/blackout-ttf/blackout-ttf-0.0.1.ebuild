# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

inherit font

DESCRIPTION="Two styles: Midnight (solid) & 2AM (reversed)"
HOMEPAGE="http://www.theleagueofmoveabletype.com/fonts/5-blackout"
SRC_URI="http://s3.amazonaws.com/theleague-production/fonts/blackout.zip"

LICENSE="CC"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

FONT_SUFFIX="ttf"
S=${WORKDIR}/Blackout
FONT_S=${S}
DOCS="please_read_me.txt"

RESTRICT="strip binchecks"
