# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
PYTHON_MODNAME="exifread"

inherit distutils
MY_P="exif-py"

DESCRIPTION="Python library to extract EXIF data from tiff and jpeg files."
HOMEPAGE="https://github.com/ianare/exif-py"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
