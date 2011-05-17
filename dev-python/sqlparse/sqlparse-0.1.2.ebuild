# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND=2

inherit distutils

DESCRIPTION="Non-validating SQL parser for Python"
HOMEPAGE="http://code.google.com/p/python-sqlparse/"
SRC_URI="http://python-sqlparse.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.4"

