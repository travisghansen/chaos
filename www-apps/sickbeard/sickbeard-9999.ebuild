# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"

inherit git-2 user

DESCRIPTION="The ultimate PVR application that downloads and manages your TV
 shows"
HOMEPAGE="http://sickbeard.com/"
EGIT_REPO_URI="https://github.com/midgetspy/Sick-Beard.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/cheetah-2.1.0
	>=dev-lang/python-2.4"
RDEPEND="${DEPEND}"


HOMEDIR="${ROOT}var/lib/${PN}"
S="${WORKDIR}/Sick-Beard"
DOCS="COPYING.txt readme.md"

pkg_setup() {
	enewgroup sickbeard
	enewuser  sickbeard -1 -1 "${HOMEDIR}" "sickbeard"
}

src_install() {
	keepdir "/var/lib/sickbeard"
	dodir "/var/run/sickbeard"
	dodir "/etc/sickbeard"
	fowners sickbeard:sickbeard /var/lib/sickbeard
	fowners sickbeard:sickbeard /var/run/sickbeard
	fowners sickbeard:sickbeard /etc/sickbeard

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	dodir "/usr/share/sickbeard"
	cp -R * "${D}/usr/share/sickbeard/"

	newbin ${FILESDIR}/${PN}.sh ${PN}
}
