# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

EAPI=3
inherit systemd

MY_PN="UniFi"

DESCRIPTION="Management Controller for UniFi APs"
HOMEPAGE="http://wiki.ubnt.com/UniFi_FAQ"
#SRC_URI="http://distfiles.one-gear.com/distfiles/${MY_PN}.unix-${PV}.zip"
SRC_URI="http://dl.ubnt.com/unifi/${PV}/${MY_PN}.unix.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

DEPEND=""
RDEPEND="${DEPEND}
		  >=dev-db/mongodb-2.0.0
		  virtual/jdk:1.7"
IUSE=""

S="${WORKDIR}/UniFi"

src_install() {
	dodir /opt
	mv ${WORKDIR}/UniFi ${D}/opt
	
	echo "CONFIG_PROTECT=\"/opt/UniFi/data/system.properties\"" > ${T}/99unifi
	doenvd ${T}/99unifi
	
	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	#systemd
	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}
