# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

EAPI=3
inherit multilib systemd

MY_PN="UniFi"

DESCRIPTION="Management Controller for UniFi APs"
HOMEPAGE="http://wiki.ubnt.com/UniFi_FAQ"
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
	dodir /usr/$(get_libdir)/unifi
	dodir /var/log/unifi
	dodir /var/lib/unifi/work
	keepdir /var/lib/unifi/data
	cp -R "${S}"/* "${D}"/usr/$(get_libdir)/unifi
	dosym /var/lib/unifi/data /usr/$(get_libdir)/unifi/data
	dosym /var/lib/unifi/work /usr/$(get_libdir)/unifi/work
	dosym /var/log/unifi /usr/$(get_libdir)/unifi/logs
	echo "CONFIG_PROTECT=\"/var/lib/unifi/data/system.properties\"" > 99unifi
	doenvd 99unifi
	
	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	
	#systemd
	systemd_dounit "${FILESDIR}"/${MY_PN}.service
}

pkg_postinst() {
	elog "After an update please run the following to clear the css/assets cache:"
	elog "emerge --config \"=${CATEGORY}/${PF}\""
}

pkg_config() {
	:
	# cleans old cache
	#[ -d "/usr/$(get_libdir)/unifi/webapps/ROOT/" ] && rm -rf "/usr/$(get_libdir)/unifi/webapps/ROOT/"
}
