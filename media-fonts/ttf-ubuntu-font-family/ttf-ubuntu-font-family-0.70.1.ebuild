# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

inherit font

MY_P="ubuntu-font-family-sources"

DESCRIPTION="Ubuntu Font Family, sans-serif typeface hinted for clarity"
HOMEPAGE="http://font.ubuntu.com/"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/${MY_P:0:1}/${MY_P}/${MY_P}_${PV}.orig.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"
RESTRICT="strip binchecks"

FONT_SUFFIX="ttf"
S="${WORKDIR}/${MY_P}-${PV}"
FONT_S=${S}
DOCS="*.txt"
