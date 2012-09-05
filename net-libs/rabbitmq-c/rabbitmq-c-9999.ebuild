# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="RabbitMQ C client"
HOMEPAGE="https://github.com/alanxz/rabbitmq-c"
SRC_URI=""
EGIT_REPO_URI="git://github.com/alanxz/rabbitmq-c.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc tools"

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=( "AUTHORS" "README.md" "THANKS" "TODO" )

src_prepare() {
	git submodule init
	git submodule update
}

src_configure() {
	eautoreconf
	econf $(use_enable tools) $(use_enable amd64 64-bit) $(use_enable doc docs)
}
