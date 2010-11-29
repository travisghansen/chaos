# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header $

EAPI=1

inherit eutils

DESCRIPTION="Logging Framework for C"
HOMEPAGE="http://log4c.sourceforge.net/"
SRC_URI="mirror://sourceforge/log4c/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc examples +expat"

RDEPEND="expat? ( dev-libs/expat )"

DEPEND="${RDEPEND}
	sys-devel/gcc
	doc? ( app-doc/doxygen )"

src_compile() {
	local myconf
	myconf="${myconf} --disable-expattest"

	econf \
		$(use_enable doc doxygen) \
		$(use_enable debug) \
		$(use_enable expat) \
		${myconf} || die "econf failed"
	emake -C src/ || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" -C src/ install || die "make install failed"
	dodoc AUTHORS ChangeLog COPYING NEWS README TODO

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
