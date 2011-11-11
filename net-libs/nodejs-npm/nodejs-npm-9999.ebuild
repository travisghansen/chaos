# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit git-2

DESCRIPTION="a package manager for node"
HOMEPAGE="http://npmjs.org/"
EGIT_REPO_URI="git://github.com/isaacs/npm.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/nodejs-0.4.12
        dev-vcs/git"
RDEPEND="${DEPEND}"

src_compile() {
	make
}

src_install() {
	make DESTDIR="${D}" install || die
}
