# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A Pythonic interface to the RabbitMQ Management HTTP API"
HOMEPAGE="http://pyrabbit.readthedocs.org/en/latest/index.html"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
