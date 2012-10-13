# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="RabbitMQ C client"
HOMEPAGE="https://github.com/alanxz/rabbitmq-c"
SRC_URI=""
EGIT_REPO_URI="git://github.com/alanxz/rabbitmq-c.git"

if [[ ${PV} != *9999* ]] ; then
	EGIT_COMMIT="tags/$(echo ${PV//_/-} | tr '[:lower:]' '[:upper:]' )"
fi

if [[ ${PV} == *9999* ]]; then
	KEYWORDS="~amd64 ~x86"
	#KEYWORDS="-*"
else
	KEYWORDS="~amd64 ~x86"
fi


LICENSE="MIT"
SLOT="0"
IUSE="doc static-libs tools"

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=( "AUTHORS" "README.md" "THANKS" "TODO" )

src_prepare() {
	git submodule init
	git submodule update
	eautoreconf
}

src_configure() {
	econf $(use_enable tools) $(use_enable amd64 64-bit) \
	  $(use_enable doc docs) $(use_enable static-libs static)
}
