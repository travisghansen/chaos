# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"

inherit eutils git-2 python user

DESCRIPTION="CouchPotato is an automatic NZB and torrent downloader"
HOMEPAGE="http://couchpotatoapp.com/"
#EGIT_REPO_URI="https://github.com/RuudBurger/CouchPotato.git"
EGIT_REPO_URI="git://github.com/RuudBurger/CouchPotatoServer.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CouchPotatoServer"
DOCS="*.md"

pkg_setup() {
	enewgroup couchpotato
	enewuser  couchpotato -1 -1 /var/lib/couchpotato couchpotato
}

src_install() {
	keepdir "/var/lib/couchpotato"
	dodir "/var/run/couchpotato"
	dodir "/etc/couchpotato"
	fowners couchpotato:couchpotato /var/lib/couchpotato
	fowners couchpotato:couchpotato /var/run/couchpotato
	fowners couchpotato:couchpotato /etc/couchpotato

	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	dodir "/usr/share/couchpotato"
	cp -R * "${D}/usr/share/couchpotato/"
	
	cp ${FILESDIR}/settings.conf.sample "${D}/etc/couchpotato/"
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
	einfo "You must copy /etc/couchpotato/settings.conf.sample"
	einfo "to /etc/couchpotato/settings.conf and set the proper"
	einfo "permissions on the file as well"
	einfo ""
	einfo "cp /etc/couchpotato/settings.conf.sample /etc/couchpotato/settings.conf"
	einfo "chown couchpotato:couchpotato /etc/couchpotato/settings.conf"
}
