# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

inherit font

MY_P="crimson"

DESCRIPTION="Crimson Text is a font family for book production in the tradition
of beautiful oldstyle typefaces."
HOMEPAGE="http://aldusleaf.org/"
SRC_URI="mirror://sourceforge/crimsontext/${MY_P}_${PV}.zip"

LICENSE="CC"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

FONT_SUFFIX="otf"
S=${WORKDIR}
FONT_S=${S}

RESTRICT="strip binchecks"
