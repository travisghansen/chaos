# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/bbswitch/bbswitch-0.4.2.ebuild,v 1.1 2012/05/06 09:38:31 pacho Exp $

EAPI="4"

inherit cmake-utils linux-mod

DESCRIPTION="A linux DVB driver for the HDHomeRun"
HOMEPAGE="http://sourceforge.net/apps/trac/dvbhdhomerun/wiki"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/linux-sources
	sys-kernel/linux-headers
	media-tv/hdhomerun"

RDEPEND=""

MODULE_NAMES="dvb_hdhomerun(dvb:kernel) \
              dvb_hdhomerun_core(dvb:kernel) \
			  dvb_hdhomerun_fe(dvb:kernel)"

CMAKE_BUILD_DIR=${S}/userhdhomerun
CMAKE_USE_DIR=${S}/userhdhomerun
pkg_setup() {
	enewuser hdhomerun -1 -1 -1 video
	
	linux-mod_pkg_setup

	BUILD_TARGETS="dvb_hdhomerun"
	BUILD_PARAMS="KERNEL_DIR=/usr/src/linux-${KV_FULL}"
}

src_compile() {
	linux-mod_src_compile
	cmake-utils_src_compile	
}

src_install() {
	insinto /etc
	doins "${S}"/etc/dvbhdhomerun
	
	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-hdhomerun.rules
	
	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	
	dodoc AUTHORS build.txt readme.txt

	linux-mod_src_install
	cmake-utils_src_install	
}
