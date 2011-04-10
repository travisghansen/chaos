# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"

inherit git

DESCRIPTION="CouchPotato is an automatic NZB and torrent downloader"
HOMEPAGE="http://couchpotatoapp.com/"
EGIT_REPO_URI="https://github.com/RuudBurger/CouchPotato.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CouchPotato"
DOCS="*.md"

pkg_setup() {
	enewgroup couchpotato
	enewuser  couchpotato -1 -1 -1 "couchpotato"

}

src_install() {
#	keepdir "/var/lib/sickbeard"
#	fowners sickbeard:sickbeard /var/lib/sickbeard

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	dodir "/opt/couchpotato"
	cp -R * "${D}/opt/couchpotato/"
	mkdir -p "${D}/var/run/couchpotato"
}
