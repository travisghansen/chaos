# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
#PYTHON_DEPEND=2
MY_P="Pympler"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python memory analyzer"
HOMEPAGE="http://code.google.com/p/pympler/"
SRC_URI="http://pypi.python.org/packages/source/P/${MY_P}/${MY_P}-${PV}.tar.gz"
S="${WORKDIR}/${MY_P}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"

