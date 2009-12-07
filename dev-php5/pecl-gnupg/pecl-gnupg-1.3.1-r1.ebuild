# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-gnupg/pecl-gnupg-1.3.1.ebuild,v 1.2 2008/06/09 19:40:02 swegener Exp $

PHP_EXT_NAME="gnupg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit php-ext-pecl-r1

KEYWORDS="~amd64 ~x86"
DESCRIPTION="PHP wrapper around the gpgme library"
LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND="app-crypt/gpgme"
RDEPEND="${DEPEND}"

src_unpack(){

	php-ext-source-r1_src_unpack
	epatch ${FILESDIR}/test.patch || die "error patching"

}

need_php_by_category
