# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2

MY_PN="Yarock"
MY_P="${MY_PN}_${PV}_source"
DESCRIPTION="Yarock is Qt4 modern music player designed to provide an easy and pretty music collection browser based on cover art."
HOMEPAGE="http://qt-apps.org/content/show.php?content=129372"
SRC_URI="http://launchpad.net/yarock/trunk/${PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=x11-libs/qt-gui-4.7.0
	>=x11-libs/qt-dbus-4.7.0
	>=x11-libs/qt-sql-4.7.0[sqlite]
	media-libs/phonon
	media-libs/taglib
"

RDEPEND="${DEPEND}"

MY_LINGUAS="cs es fr pt-BR ro ru"
for MY_LINGUA in ${MY_LINGUAS}; do
	IUSE="${IUSE} linguas_${MY_LINGUA/-/_}"
done

DOCS="CHANGES README"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Pro file
	MY_PF="${PN}.pro"

	# Fix package target & executable
	sed -i -e "/^TARGET/s:= YaRock:= ${PN}:" ${MY_PF} || die "Failed to fix package target!"
	sed -i -e "/^Exec/s:=YaRock:=${PN}:" data/${PN}.desktop || die "Failed to fix package executable!"

	# Fix install paths
	sed -i -e "s:PREFIX = /usr/local:PREFIX = /usr:" ${MY_PF} || die "Failed to fix install prefix!"
	sed -i -e "s:LOCALEDIR.*/locale/YaRock:LOCALEDIR = \$\$SHAREDIR/${PN}/translation:" ${MY_PF} || die "Failed to fix locale path!"
	sed -i -e "s:PKGDATADIR.*/YaRock:PKGDATADIR = \$\$SHAREDIR/${PN}:" ${MY_PF} || die "Failed to fix package path!"

	# Remove unwanted linguas
	if [[ ${LINGUAS} != "" ]]; then
		einfo "Keeping these locales: ${LINGUAS}."
	fi
	for LINGUA in ${MY_LINGUAS}; do
		if ! use linguas_${LINGUA/-/_}; then
			sed -i \
				-e "/^TRANSLATIONS.*${PN}_${LINGUA/-/_}/d" ${MY_PF} \
				-e "/translations.files.*${PN}_${LINGUA/-/_}/d" ${MY_PF} \
			|| die "Couldn't remove ${LINGUA/-/_} lingua!"
		fi
	done

	qt4-r2_src_prepare
}
