# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3

inherit eutils

DESCRIPTION="collection of advanced MySQL command-line tools"
HOMEPAGE="http://www.percona.com/software/percona-toolkit/"
SRC_URI="http://www.percona.com/redir/downloads/percona-toolkit/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
SLOT="0"
IUSE=""

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
DEPEND=">=dev-lang/perl-5.8
	>=app-shells/bash-3"

RDEPEND="${DEPEND}
	dev-perl/DBD-mysql
	dev-perl/DBI
	virtual/perl-Time-HiRes"

src_compile() {
	# generate proper makefiles
	perl Makefile.PL
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/percona-toolkit
	dodoc Changelog COPYING INSTALL README
}
