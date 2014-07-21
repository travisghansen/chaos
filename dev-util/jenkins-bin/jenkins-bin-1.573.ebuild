inherit java-pkg-2 rpm user

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://jenkins-ci.org/"
LICENSE="MIT"
# We are using rpm package here, because we want file with version.
SRC_URI="http://pkg.jenkins-ci.org/redhat/RPMS/noarch/jenkins-${PV}-1.1.noarch.rpm"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-fonts/dejavu"
RDEPEND="${DEPEND}
        >=virtual/jdk-1.5"

MY_PN="jenkins"

src_unpack() {
    rpm_src_unpack ${A}
}

pkg_setup() {
    enewgroup jenkins
    enewuser jenkins -1 /bin/bash /var/lib/jenkins jenkins
}

src_install() {
    keepdir /var/run/jenkins /var/log/jenkins
    keepdir /var/lib/jenkins/home /var/lib/jenkins/backup

    insinto /usr/lib/jenkins
    doins usr/lib/jenkins/jenkins.war

    newinitd "${FILESDIR}/init.sh" ${MY_PN}
    newconfd "${FILESDIR}/conf" ${MY_PN}
	
	dodir /etc/logrotate.d
	cp ${FILESDIR}/${MY_PN}.logrotate ${D}/etc/logrotate.d/${MY_PN} || die \
	 "failed copying lograte file into place"

    fowners jenkins:jenkins /var/run/jenkins /var/log/jenkins /var/lib/jenkins /var/lib/jenkins/home /var/lib/jenkins/backup
}
