# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1.ebuild,v 1.6 2005/01/01 15:15:35 eradicator Exp $

EAPI=5

inherit eutils systemd

DESCRIPTION="a tool for managing events and logs."
HOMEPAGE="http://logstash.net/"
DIST="flatjar"
SRC_URI="https://download.elasticsearch.org/${PN}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="x86 amd64 lpha sparc"
IUSE=""

DEPEND="dev-python/pyes
	dev-python/urllib3"

RDEPEND="virtual/jre"

LS_ROOT_PATH="/opt/logstash"

src_install() {
	insinto /etc/${PN}/conf.d
	doins "${FILESDIR}/agent.conf.sample"

	keepdir "/etc/${PN}/patterns"
	keepdir "/etc/${PN}/plugins"
	keepdir "/var/lib/${PN}"
	keepdir "/var/log/${PN}"
	
	# copy files
	dodir "${LS_ROOT_PATH}"
	cp -R "${S}"/* "${D}/${LS_ROOT_PATH}/"
	
	# symlink launcher
	# dosym "${LS_ROOT_PATH}/bin/${PN}" "/usr/bin/${PN}"

	# requires pyes
	# https://logstash.jira.com/browse/LOGSTASH-211
	dobin ${FILESDIR}/logstash_index_cleaner.py
	dobin ${FILESDIR}/logstash
	
	dodir /etc/logrotate.d
	cp ${FILESDIR}/logstash.logrotate ${D}/etc/logrotate.d/${PN} || die \
	 "failed copying lograte file into place"

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	
	#systemd
	systemd_dounit "${FILESDIR}"/${PN}-agent.service
	systemd_dounit "${FILESDIR}"/${PN}-web.service
}

pkg_postinst() {
	einfo "some useful links for getting started"
	einfo "  https://github.com/logstash/logstash/wiki"
	einfo "  http://cookbook.logstash.net/"
	einfo "  http://www.logstash.net/docs/${PV}/"
	einfo "  https://github.com/logstash/logstash/tree/v${PV}/patterns"
}
