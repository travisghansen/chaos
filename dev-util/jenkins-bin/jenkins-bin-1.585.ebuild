# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

EAPI=5

inherit user

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
LICENSE="MIT"
# We are using rpm package here, because we want file with version.
SRC_URI="http://mirrors.jenkins-ci.org/war/${PV}/jenkins.war -> ${P}.war"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-fonts/dejavu"
RDEPEND="${DEPEND}
        >=virtual/jdk-1.5"

MY_PN="jenkins"
S="${WORKDIR}"

pkg_setup() {
    enewgroup jenkins
    enewuser jenkins -1 /bin/bash /var/lib/jenkins jenkins
}

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}/jenkins.war"
}

src_install() {
    keepdir /var/run/jenkins /var/log/jenkins
    keepdir /var/lib/jenkins/home /var/lib/jenkins/backup

    insinto /usr/lib/jenkins
	doins "jenkins.war"

    newinitd "${FILESDIR}/init.sh" ${MY_PN}
    newconfd "${FILESDIR}/conf" ${MY_PN}
	
	dodir /etc/logrotate.d
	cp ${FILESDIR}/${MY_PN}.logrotate ${D}/etc/logrotate.d/${MY_PN} || die \
	 "failed copying lograte file into place"

    fowners jenkins:jenkins /var/run/jenkins /var/log/jenkins /var/lib/jenkins /var/lib/jenkins/home /var/lib/jenkins/backup
}
