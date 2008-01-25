# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="Transmission"

DESCRIPTION="Transmission is a free, lightweight BitTorrent client."
HOMEPAGE="http://transmission.m0k.org/"
SRC_URI="http://transmission.m0k.org/files/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk ssl"


DEPEND=""
RDEPEND="gtk? ( x11-libs/gtk+ )
		ssl? ( dev-libs/openssl )"


S="${WORKDIR}/${MY_PN}-${PV}"



src_compile() {

	local myconf
	if ! use gtk;then
		myconf="${myconf} --disable-gtk"
	fi

	if ! use ssl;then
		myconf="${myconf} --disable-openssl"
	fi

	econf $myconf
	emake

}

src_install() {

	dobin gtk/transmission-gtk
	dobin cli/transmissioncli

}
