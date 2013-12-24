# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_DEPEND="2"

MY_PN="scikits.${PN}"
PYTHON_MODNAME="scikits"

inherit distutils

DESCRIPTION="A python module to make noise from numpy arrays"
HOMEPAGE="http://cournape.github.com/audiolab"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="dev-python/numpy
	media-libs/libsndfile"

S="${WORKDIR}/${MY_PN}-${PV}"
