# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Java program that offers two-way synchronization between Google Calendar and various iCalendar compatible calendar applications."
HOMEPAGE="http://gcaldaemon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-linux-${PV/_/-}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jre-1.5"
DEPEND="${RDEPEND}"

inherit java-pkg-2

src_compile() {
	return 0
}

src_install() {
	cd GCALDaemon
	java-pkg_dojar lib/*.jar
	local j
	if use doc; then
		dohtml -r docs/* || die "failed to install docs"
	fi
	exeinto /usr/bin
	doexe ${FILESDIR}/gcaldaemon
}
