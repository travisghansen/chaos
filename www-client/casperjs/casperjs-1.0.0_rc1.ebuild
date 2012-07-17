# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"

inherit eutils git-2

EGIT_REPO_URI="git://github.com/n1k0/casperjs.git"
if [[ ${PV} != *9999* ]] ; then
	EGIT_COMMIT="tags/$(echo ${PV//_/-} | tr '[:lower:]' '[:upper:]' )"
fi

if [[ ${PV} == *9999* ]]; then
	KEYWORDS="-*"
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="navigation scripting & testing utility for PhantomJS"
HOMEPAGE="http://casperjs.org/"
LICENSE=""
RESTRICT="mirror"
SLOT="0"

DEPEND="|| ( ( >=www-client/phantomjs-bin-1.5.0 ) ( >=www-client/phantomjs-1.5.0 ) )"
RDEPEND="${DEPEND}"

src_install(){
	dodir "/opt/${PN}"
	cp -R "${S}"/* "${D}/opt/${PN}"

	chown -R root:root "${D}/opt/${PN}"
	dosym /opt/${PN}/bin/casperjs /usr/bin/casperjs  
}

