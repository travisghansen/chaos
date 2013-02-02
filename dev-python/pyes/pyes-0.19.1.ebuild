# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
#SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="a connector to use elasticsearch from python"
HOMEPAGE="http://pypi.python.org/pypi/pyes/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/simplejson"
