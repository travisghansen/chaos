# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-murrine/gtk-engines-murrine-0.90.3-r1.ebuild,v 1.7 2010/02/14 06:23:53 nirbheek Exp $

EAPI="2"

inherit base eutils gnome.org versionator

MY_PN="unico"
DESCRIPTION="aims to be the more complete yet powerful theming engine"
HOMEPAGE="https://launchpad.net/unico"
SRC_URI="http://launchpad.net/${MY_PN}/$(get_version_component_range 1-2)/$(get_version_component_range 1-3)/+download/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"

RDEPEND=">=x11-libs/gtk+-3.1.10
		 >=dev-libs/glib-2.26.0
		 >=x11-libs/cairo-1.10"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1
	sys-devel/gettext
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	base_src_install
}
