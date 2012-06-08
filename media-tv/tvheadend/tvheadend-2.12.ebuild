# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

MY_PN="hts-${PN}"

DESCRIPTION="Tvheadend is a combined DVB receiver, Digital Video Recorder and Live TV streaming server"
HOMEPAGE="http://www.lonelycoder.com/hts/"
SRC_URI="http://www.lonelycoder.com/debian/dists/hts/main/source/${MY_PN}_${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi xmltv"

DEPEND="dev-libs/openssl
	virtual/linuxtv-dvb-headers"

RDEPEND="${DEPEND}
	xmltv? ( media-tv/xmltv )
	avahi? ( net-dns/avahi )"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_configure() {
	econf \
		--prefix=/usr \
		--mandir=/usr/share/man/man1 \
		--datadir=/usr/share/tvheadend \
		$(use_enable avahi) \
		--release \
		|| die "Configure failed!"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed!"

	dodoc README

	newinitd "${FILESDIR}/tvheadend.initd" tvheadend
	newconfd "${FILESDIR}/tvheadend.confd" tvheadend

	dodir /etc/tvheadend
	fperms 0700 /etc/tvheadend
	fowners tvheadend:video /etc/tvheadend
}

pkg_postinst() {
	elog "To start Tvheadend:"
	elog "/etc/init.d/tvheadend start"
	elog
	elog "To start Tvheadend at boot:"
	elog "rc-update add tvheadend default"
	elog
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."
}
