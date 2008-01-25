# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:
inherit eutils

DESCRIPTION="FLAIM is an embeddable cross-platform database engine that provides
a rich, powerful, easy-to-use feature set."
HOMEPAGE="http://forge.novell.com/modules/xfmod/project/?flaim"
SRC_URI="http://forgeftp.novell.com/flaim/release/flaim/downloads/source/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
RESTRICT="mirror"

RDEPEND=""

DEPEND="${RDEPEND}"

src_compile() {
	make DESTDIR=${D} OSTYPE=`uname -s` HOSTTYPE=`uname -m`  || \
	die "Error compiling ${PN}"
}

src_install() {
	make DESTDIR=${D} install OSTYPE=`uname -s` HOSTTYPE=`uname -m` || \
	die "Error installing ${PN}"
}
