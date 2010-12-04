# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit versionator eutils python

DESCRIPTION="Extensions to the engine such as Teamgeist, Relevancy Providers and
Machine Learning Algorithms"
HOMEPAGE="https://launchpad.net/zeitgeist-extensions"
#SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug +fts gps profile"

DEPEND="gnome-extra/zeitgeist
	fts? ( dev-libs/xapian-bindings[python] )"
RDEPEND="${DEPEND}"

pkg_setup() {
	# install python-sqlparse from http://code.google.com/p/python-sqlparse/
	use debug && die "missing necessary deps in portage"

	# needs Geoclue
	use gps && die "missing necessary deps in portage"

	# http://code.google.com/p/pympler/
	use profile && die "missing necessary deps in portage"

}

src_install() {
	#emake install DESTDIR="${D}" || die "Failed to install"
	EXTENSION_DIR="/usr/share/zeitgeist/_zeitgeist/engine/extensions/"

	if use fts;then
		insinto "${EXTENSION_DIR}"
		doins "${S}/fts/fts.py"
	fi
}
