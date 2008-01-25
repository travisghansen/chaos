# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Ubuntu System Panel for GNOME"
HOMEPAGE="http://ubuntu-system-panel.googlecode.com/"
SRC_URI="http://ultra.hivalley.com/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""



src_install(){

	cp -R ${WORKDIR}/* ${D}

}

