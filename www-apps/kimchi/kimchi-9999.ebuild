# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="2"

inherit git-2 user

DESCRIPTION="An HTML5 management interface for KVM"
HOMEPAGE="https://github.com/kimchi-project/kimchi"
EGIT_REPO_URI="https://github.com/kimchi-project/kimchi.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/libxslt
	>=dev-python/cheetah-2.0.4	
	dev-python/cherrypy
	dev-python/ipaddr
	dev-python/jsonschema
	dev-python/lxml
	dev-python/m2crypto
	dev-python/psutil
	dev-python/pypam
	dev-python/pyparted
	dev-python/python-ethtool
	dev-python/libvirt-python
	>=dev-lang/python-2.4
	virtual/python-imaging
	www-servers/nginx"
RDEPEND="${DEPEND}"


HOMEDIR="${ROOT}var/lib/${PN}"
#S="${WORKDIR}/Sick-Beard"
DOCS="AUTHORS COPYING INSTALL README NEWS ChangeLog VERSION"

pkg_setup() {
	:
	#enewgroup sickbeard
	#enewuser  sickbeard -1 -1 "${HOMEDIR}" "sickbeard"
}

src_configure() {
	./autogen.sh --system
}

src_compile() {
	emake
}

src_install() {
	keepdir "/var/lib/${PN}"
	dodir "/var/run/${PN}"
	dodir "/etc/${PN}"
	#fowners sickbeard:sickbeard /var/lib/sickbeard
	#fowners sickbeard:sickbeard /var/run/sickbeard
	#fowners sickbeard:sickbeard /etc/sickbeard

	#Init scripts
	#newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	#newinitd "${FILESDIR}/${PN}.init" "${PN}"

	#dodir "/usr/share/sickbeard"
	#cp -R * "${D}/usr/share/sickbeard/"

	#newbin ${FILESDIR}/${PN}.sh ${PN}

	emake DESTDIR=${D} install

}
