# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit multilib eutils

BASE_URI="http://www.percona.com/downloads/XtraBackup"
MY_PN="XtraBackup"
MY_P="${PN:0:-4}-${PV}"

DESCRIPTION="OpenSource online (non-blockable) backup tool for InnoDB and XtraDB engines"
HOMEPAGE="http://www.percona.com/software/percona-xtrabackup/"
SRC_URI="amd64? ( ${BASE_URI}/${MY_PN}-${PV}/binary/Linux/x86_64/${MY_P}.tar.gz -> ${MY_P}.x86_64.tar.gz )
         x86? ( ${BASE_URI}/${MY_PN}-${PV}/binary/Linux/i686/${MY_P}.tar.gz -> ${MY_P}.i686.tar.gz )"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib
	dev-libs/libaio
	virtual/perl-Getopt-Long
	virtual/perl-File-Spec
	virtual/perl-File-Temp"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodir /usr/bin
	cp -R bin/* "${D}"/usr/bin
}
