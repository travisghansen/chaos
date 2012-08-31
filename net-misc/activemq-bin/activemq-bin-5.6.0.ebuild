# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The most popular and powerful open source Message Broker and Enterprise Integration Patterns provider."
HOMEPAGE="http://activemq.apache.org/"

MY_PN="${PN/-bin/}"
# http://www.reverse.net/pub/apache/activemq/apache-activemq/5.6.0/apache-activemq-5.6.0-bin.tar.gz
SRC_URI="mirror://apache/${MY_PN}/apache-${MY_PN}/${PV}/apache-${MY_PN}-${PV}-bin.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS="-*"

IUSE="doc example"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

#TODO
# create activemq user
# change startup scripts to use user etc
# keepdir for /var/lib/activemq
# keepdir for /etc/activemq for 'conf' dir
# other goodies

src_install() {
	insinto /opt/${MY_PN}/
	doins -r bin || die
	doins -r conf || die
	doins -r lib || die
	doins -r data || die
	doins -r webapps || die
	if use doc ; then
		doins -r docs || die
	fi
	if use example ; then
		doins -r example || die
	fi

	newinitd "${FILESDIR}/${MY_PN}.init" ${MY_PN} || die "Inserting init.d-file failed"
	newconfd "${FILESDIR}/${MY_PN}.conf" ${MY_PN} || die "Inserting conf.d-file failed"

}

