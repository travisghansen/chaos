# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# require python-2 (min version 2.5) with sqlite USE flag
EAPI="3"

PYTHON_DEPEND="2:2.5"

inherit eutils git-2 multilib python

#EGIT_REPO_URI="http://git.sukimashita.com/totem-plugin-airplay.git"
#if [[ ${PV} != *9999* ]] ; then
#	EGIT_COMMIT="tags/$(echo ${PV//_/-} | tr '[:lower:]' '[:upper:]' )"
#fi

#if [[ ${PV} == *9999* ]]; then
#	KEYWORDS="-*"
#else
#	KEYWORDS="~amd64 ~x86"
#fi

# works with latest totem
EGIT_REPO_URI="git://github.com/dveeden/totem-plugin-airplay.git"

DESCRIPTION="AirPlay plugin for totem"
HOMEPAGE="https://github.com/dveeden/totem-plugin-airplay"
KEYWORDS="amd64 ~amd64 x86 ~x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="media-video/totem[python,introspection]
	dev-libs/libpeas
	dev-libs/gobject-introspection
	net-dns/avahi[python]
	dev-python/dbus-python"
DEPEND="${RDEPEND}"

PLUGIN_DIR="/usr/$(get_libdir)/totem/plugins/airplay"

src_install() {
	dodir ${PLUGIN_DIR}
	cp * ${D}/${PLUGIN_DIR}
}

pkg_postinst() {
	python_mod_optimize ${PLUGIN_DIR}
}

pkg_postrm() {
	python_mod_cleanup ${PLUGIN_DIR}
}
