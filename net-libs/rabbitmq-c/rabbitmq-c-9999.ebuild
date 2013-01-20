# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit cmake-utils eutils multilib

DESCRIPTION="RabbitMQ C client"
HOMEPAGE="https://github.com/alanxz/rabbitmq-c"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/alanxz/rabbitmq-c.git"
	KEYWORDS="-*"
else
	SRC_URI="https://github.com/alanxz/rabbitmq-c/archive/${PN}-v${PV}.zip"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples static-libs tools"

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=( "AUTHORS" "README.md" "THANKS" "TODO" )
PATCHES=( "${FILESDIR}/xmlto.patch" )

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-2_src_unpack
	else
		unpack ${A}
		mv ${PN}* ${P} || die
	fi
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		$(cmake-utils_use examples BUILD_EXAMPLES)
		$(cmake-utils_use tools BUILD_TOOLS)
		$(cmake-utils_use tools BUILD_TOOLS_DOCS)
		$(cmake-utils_use static-libs BUILD_STATIC_LIBS)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		cd "${CMAKE_BUILD_DIR}"/examples
		exeinto /usr/$(get_libdir)/${PN}/examples
		doexe $(find ./ -executable -type f)
	fi
}
