# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1.ebuild,v 1.6 2005/01/01 15:15:35 eradicator Exp $

inherit eutils

DESCRIPTION="a tool for managing events and logs."
HOMEPAGE="http://logstash.net/"
SRC_URI="https://logstash.objects.dreamhost.com/release/${P}-flatjar.jar"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="x86 amd64 lpha sparc"
IUSE=""

DEPEND=""

RDEPEND="virtual/jre"
S="${WORKDIR}"

src_unpack() {
	:
}

src_configure() {
	:
}
src_install() {
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"
	dodir "/opt/${PN}/"
	insinto "/opt/${PN}"
	doins "${DISTDIR}/${P}-flatjar.jar"

	dosym "/opt/${PN}/${A}" "/opt/${PN}/${PN}.jar"
	exeinto "/opt/bin"
	doexe ${FILESDIR}/logstash

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	#newinitd "${FILESDIR}/${PN}.init" "${PN}"
}

pkg_postinst() {
	einfo "some useful links for getting started"
	einfo "  https://github.com/logstash/logstash/wiki"
	einfo "  http://cookbook.logstash.net/"
	einfo "  http://www.logstash.net/docs/${PV}/"
	einfo "  https://github.com/logstash/logstash/tree/v${PV}/patterns"
}
