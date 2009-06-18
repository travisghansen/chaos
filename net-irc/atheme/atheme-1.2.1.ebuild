# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/atheme/atheme-1.2.1.ebuild,v 1.4 2008/05/21 18:55:28 dev-zero Exp $

inherit eutils autotools

DESCRIPTION="A portable, secure set of open source, and modular IRC services"
HOMEPAGE="http://www.atheme.net/"
SRC_URI="http://www.atheme.net/releases/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc ~x86 ~x86-fbsd"
IUSE="largenet postgres"

RDEPEND="postgres? ( virtual/postgresql-server )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.59"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/atheme-1.2.1-postgresl.patch

	eautoreconf
}

src_compile() {
	econf \
		--prefix=/var/lib/atheme \
		$(use_enable postgresql) \
		$(use_with largenet large-net) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make prefix="${D}"/var/lib/atheme install || die "make install failed"

	dodir /usr/{lib,share}/atheme /etc
	keepdir /var/lib/atheme/var
	fowners atheme:atheme /var/lib/atheme/var
	fperms 750 /var/lib/atheme/var

	local dir
	for dir in backend crypto modules protocol
	do
		mv "${D}"/var/lib/atheme/${dir} "${D}"/usr/lib/atheme
		dosym /usr/lib/atheme/${dir} /var/lib/atheme/${dir}
	done

	mv "${D}"/var/lib/atheme/help "${D}"/usr/share/atheme
	dosym /usr/share/atheme/help /var/lib/atheme/help

	mv "${D}"/var/lib/atheme/etc "${D}"/etc/atheme
	cp "${D}"/etc/atheme/example.conf "${D}"/etc/atheme/atheme.conf
	fowners root:atheme /etc/atheme/atheme.conf
	fperms 640 /etc/atheme/atheme.conf
	dosym /etc/atheme /var/lib/atheme/etc

	dobin "${D}"/var/lib/atheme/bin/atheme || die "dobin failed"

	dodoc \
		ChangeLog INSTALL README \
		doc/{example_module.c,LICENSE,SQL,RELEASE} \
		|| die "dodoc failed"

	newinitd "${FILESDIR}"/atheme.initd atheme

	# And remove stuff we don't need
	rm -rf "${D}"/var/lib/atheme/{bin,doc}
}

pkg_setup() {
	enewgroup atheme
	enewuser atheme -1 -1 /var/lib/atheme atheme
}

pkg_postinst() {
	elog
	elog "Don't forget to edit /etc/atheme/atheme.conf!"
	elog
}
