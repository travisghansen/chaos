# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"

inherit git

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

S="${WORKDIR}/Sick-Beard"
DOCS="COPYING.txt readme.md"

pkg_setup() {
	enewgroup sickbeard
	enewuser  sickbeard -1 -1 -1 "sickbeard"

}

src_prepare() {

	#epatch "${FILESDIR}/all.patch"
	epatch "${FILESDIR}/options.patch"
	epatch "${FILESDIR}/db.patch"
	epatch "${FILESDIR}/main_db.patch"

}

src_install() {
	keepdir "/var/lib/sickbeard"
	fowners sickbeard:sickbeard /var/lib/sickbeard

	dodir "/usr/share/sickbeard"
	cp -R * "${D}/usr/share/sickbeard/"
}

pkg_postinst() {
	elog "This is a test"
}
