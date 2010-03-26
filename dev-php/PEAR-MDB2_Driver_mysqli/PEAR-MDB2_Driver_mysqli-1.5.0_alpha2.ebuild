# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-MDB2_Driver_mysqli/PEAR-MDB2_Driver_mysqli-1.5.0_alpha2.ebuild,v 1.8 2008/11/09 11:48:53 vapier Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Database Abstraction Layer, mysqli driver"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=">=dev-php/PEAR-MDB2-2.5.0_alpha2"
RDEPEND="${DEPEND}"

need_php5

pkg_setup() {
	require_php_with_use mysqli
}
