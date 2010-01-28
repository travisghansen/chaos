# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Command-line utility for sending jabber messages"
HOMEPAGE="http://xmpppy.sourceforge.net/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64 ~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/python
		dev-python/xmpppy"
RDEPEND="${DEPEND}"

MY_APP="${PN#xmpppy-}"
MY_FILE="${MY_APP}.py"

src_unpack() { : ; }
src_prepare() { 
	mkdir "${S}"
	cp "${FILESDIR}/${MY_FILE}" "${S}" || die $1
	cd "${S}"
	if [ -f "${FILESDIR}/${P}.patch" ];then
		epatch "${FILESDIR}/${P}.patch"
	fi
}
src_configure() { : ; }
src_unpack() { : ; }
src_install() {
	newbin "${S}/${MY_FILE}" ${MY_APP}
	if [ -f "${FILESDIR}/${PN}-config-${PV}" ];then
		insinto "/etc/${MY_APP}"
		newins "${FILESDIR}/${PN}-config-${PV}" "${MY_APP}"
	elif [ -f "${FILESDIR}/${PN}-config" ]; then
		insinto "/etc/${MY_APP}"
		newins "${FILESDIR}/${PN}-config" "${MY_APP}"
	fi
		
}

pkg_postinst() {
	elog "Please be careful with your jid and passwords being saved in"
	elog "clear-text files"
}
