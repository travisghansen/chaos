# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"
inherit eutils python versionator

DESCRIPTION="Extensions to the zeitgeist engine"
HOMEPAGE="https://launchpad.net/zeitgeist-extensions"
#SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
SRC_URI="http://launchpad.net/${PN}/trunk/fts-${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#KEYWORDS="-*"
#IUSE="debug +fts geolocation profile tracker"
IUSE="+fts geolocation"

DEPEND="app-misc/zeitgeist
	fts? ( dev-libs/xapian-bindings[python] )
	geolocation? ( dev-python/python-geoclue )"

#	debug? ( dev-python/sqlparse )
#	profile? ( dev-python/pympler
#			   dev-python/dbus-python )
#	tracker? ( >=app-misc/tracker-0.12.5 )

RDEPEND="${DEPEND}"

EXTENSION_DIR="/usr/share/zeitgeist/_zeitgeist/engine/extensions/"

src_install() {
	#emake install DESTDIR="${D}" || die "Failed to install"

	if use debug;then
		insinto "${EXTENSION_DIR}"
		doins "${S}/debug_sql/debug_sql.py"
	fi

	if use fts;then
		insinto ${EXTENSION_DIR}
		doins "${S}"/fts/fts.py
	fi

	if use geolocation;then
		insinto ${EXTENSION_DIR}
		doins "${S}"/geolocation/geolocation.py
	fi

	if use profile;then
		insinto ${EXTENSION_DIR}
		doins "${S}"/memory-profile/profile_memory.py
	fi

	if use tracker;then
		insinto ${EXTENSION_DIR}
		doins "${S}"/tracker/tracker.py
	fi
}

pkg_postinst() {
	python_mod_optimize "${EXTENSION_DIR}"
}

pkg_postrm() {
	python_mod_cleanup "${EXTENSION_DIR}"
}
