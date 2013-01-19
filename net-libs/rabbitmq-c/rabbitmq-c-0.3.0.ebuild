# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit cmake-utils eutils

DESCRIPTION="RabbitMQ C client"
HOMEPAGE="https://github.com/alanxz/rabbitmq-c"
SRC_URI="https://github.com/alanxz/rabbitmq-c/archive/${PN}-v${PV}.zip"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="examples static-libs tools"

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=( "AUTHORS" "README.md" "THANKS" "TODO" )
PATCHES=( "${FILESDIR}/xmlto.patch" )

src_unpack() {
	unpack ${A}
	mv ${PN}* ${P} || die
}

src_configure() {
	mycmakeargs=(
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
		docompress -x /usr/share/doc/${PF}/examples
		cd "${CMAKE_BUILD_DIR}"/examples
		exeinto /usr/share/doc/${PF}/examples
		doexe $(find ./ -executable -type f)
	fi
}
