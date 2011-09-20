# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

EAPI=3

DESCRIPTION="Pastebin from the commandline"
HOMEPAGE="https://github.com/oremj/pastebinit"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="dev-lang/python:2.7"

DEPEND="${RDEPEND}"

src_compile() {
	einfo "Nothing to be done, continuing..."
}

src_install() {
	dobin "${FILESDIR}"/${P}.py
	dosym /usr/bin/${P}.py /usr/bin/pastebinit
}
