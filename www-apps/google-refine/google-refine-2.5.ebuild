# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mtail/mtail-1.1.1.ebuild,v 1.6 2005/01/01 15:15:35 eradicator Exp $

inherit eutils user

REVISION=2407

DESCRIPTION="a power tool for working with messy data, and cleaning it up"
HOMEPAGE="http://code.google.com/p/google-refine/"
SRC_URI="http://google-refine.googlecode.com/files/${PN}-${PV/_/-}-r${REVISION}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="x86 amd64 lpha sparc"
IUSE=""

DEPEND=""

RDEPEND="virtual/jre"


HOMEDIR="${ROOT}var/lib/${PN}"
S="${WORKDIR}/${PN}-${PV%_rc*}"
#DOCS="README.txt LICENSE.txt"

pkg_setup() {
	enewgroup ${PN}
	enewuser  ${PN} -1 -1 "${HOMEDIR}" "${PN}"
}

src_install() {
	keepdir "/var/log/${PN}"
	keepdir "/var/lib/${PN}"
	dodir "/var/run/${PN}"
	dodir "/opt/${PN}/.import-temp"
	fowners ${PN}:${PN} /var/log/${PN}
	fowners ${PN}:${PN} /var/lib/${PN}
	fowners ${PN}:${PN} /var/run/${PN}
	fowners ${PN}:${PN} "/opt/${PN}/.import-temp"

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	cp -R * "${D}/opt/${PN}"
}
