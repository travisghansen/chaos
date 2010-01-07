# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

inherit font

DESCRIPTION="Junction is where the best qualities of serif and sans serif typefaces come together."
HOMEPAGE="http://www.theleagueofmoveabletype.com/fonts/1-junction"
SRC_URI="http://s3.amazonaws.com/theleague-production/fonts/junction.zip"

LICENSE="CC"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

FONT_SUFFIX="otf"
S="${WORKDIR}/Junction opentype"
FONT_S=${S}

RESTRICT="strip binchecks"
