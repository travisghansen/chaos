# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

inherit font

MY_P="SourceSansPro"

DESCRIPTION="A set of OpenType fonts designed for user interfaces"
HOMEPAGE="http://store1.adobe.com/cfusion/store/html/index.cfm?store=OLS-US&event=displayFontPackage&code=1959"
SRC_URI="mirror://sourceforge/sourcesans.adobe/${MY_P}_FontsOnly-${PV}.zip"

# actually SIL Open Font License
LICENSE="CC"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

FONT_SUFFIX="otf"
S="${WORKDIR}/${MY_P}_FontsOnly-${PV}"
FONT_S=${S}/OTF

RESTRICT="strip binchecks"
