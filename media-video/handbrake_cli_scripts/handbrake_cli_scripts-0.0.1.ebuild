# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="cli helper scripts for HandBrake"
HOMEPAGE="http://trac.one-gear.com/chaos/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""
RDEPEND="media-video/handbrake"
DEPEND="$RDEPEND"

SCRIPTS="handbrake_cli_dvd_episodes.sh"

src_install() {
	for SCRIPT in ${SCRIPTS};do
		dobin "${FILESDIR}/${SCRIPT}"
	done
}
