# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
PYTHON_MODNAME="qmf"

inherit distutils

DESCRIPTION="qpid QMF APIs"
HOMEPAGE="http://qpid.apache.org/"
# http://www.apache.org/dyn/closer.cgi/qpid/0.16/qpid-python-0.16.tar.gz
SRC_URI="mirror://apache/qpid/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="~dev-python/qpid-python-${PV}"
RDEPEND="${DEPEND}"
