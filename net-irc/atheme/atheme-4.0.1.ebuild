# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/atheme/atheme-1.2.1.ebuild,v 1.4 2008/05/21 18:55:28 dev-zero Exp $

inherit eutils autotools

MY_P="${PN}-services"

DESCRIPTION="A portable, secure set of open source, and modular IRC services"
HOMEPAGE="http://www.stack.nl/~jilles/irc/#atheme"
SRC_URI="http://www.stack.nl/~jilles/irc/${MY_P}-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc ~x86 ~x86-fbsd ~amd64"
IUSE="largenet ssl nls pcre"

RDEPEND=""
DEPEND="${RDEPEND}
	pcre? ( >=dev-libs/libpcre-7.9-r1 )
	>=dev-libs/libmowgli-0.7.0
	>=sys-devel/autoconf-2.59"

S=${WORKDIR}/${MY_P}-${PV}

src_compile() {
	
	myconf="--enable-fhs-paths --disable-rpath"
	myconf="${myconf} --localstatedir=/var --libdir=/usr/$(get_libdir)"
	myconf="${myconf} --sysconfdir=/etc/${PN}"
	myconf="${myconf} --docdir=/usr/share/doc/${PN}-${PV}"
	use pcre  && myconf="${myconf} --with-pcre"

	econf \
		$(use_enable ssl) \
		$(use_enable nls) \
		$(use_with largenet large-net) \
		${myconf} \
		|| die "econf failed"
	
	make || die "make failed"
}

src_install() {

	mkdir -p ${D}/etc/${PN}

	for EACH in $(ls ./dist/*example);do
		cp "${EACH}" "${D}/etc/${PN}"
	done;

#	cp "${D}/etc/${PN}/${PN}.conf.example" "${D}/etc/${PN}/${PN}.conf"
	cp "./dist/${PN}.conf.example" "${D}/etc/${PN}/${PN}.conf"

	emake DESTDIR=${D} install

	dodoc \
		NEWS INSTALL README \
		TODO COPYING ABOUT-NLS \
		|| die "dodoc failed"

	newinitd "${FILESDIR}"/${PN}-${PV}.initd atheme

}

pkg_setup() {
	enewgroup atheme
	enewuser atheme -1 -1 /var/lib/atheme atheme
}

pkg_postinst() {
	
	einfo "Setting permissions..."

	chown -R atheme:atheme /etc/${PN}
	chown -R atheme:atheme /var/run/${PN}
	chown -R atheme:atheme /var/lib/${PN}
	chown -R atheme:atheme /var/log/${PN}
	chmod 640 /etc/${PN}/*
	
	elog
	elog "Don't forget to edit /etc/atheme/atheme.conf!"
	elog
}
