# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit rpm

DESCRIPTION="Visual hardware notifications for Linux"
HOMEPAGE="http://udev-notify.learnfree.eu/"
SRC_URI="http://udev-notify.learnfree.eu/download/${P}-1.noarch.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-python/notify-python"
DEPEND="${RDEPEND}"

src_unpack() {
	rpm_src_unpack
}

src_install() {
	cp -dR ${WORKDIR}/* ${D}
}

