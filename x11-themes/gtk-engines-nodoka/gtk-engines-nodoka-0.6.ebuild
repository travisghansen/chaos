# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: nareshov $

MY_PN="gtk-nodoka-engine"
MY_P=${MY_PN}-${PV}
DESCRIPTION="GTK+2 Nodoka Theme Engine"
HOMEPAGE="https://hosted.fedoraproject.org/projects/nodoka/"
SRC_URI="http://www.unpluggedpodcast.dreamhosters.com/ian/gtk-nodoka-engine-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~*"
IUSE="static"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

RDEPEND=">=x11-libs/gtk+-2"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf="$(use_enable static) --enable-animation"

	econf $myconf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS README
	ewarn "You may need to download and manually install the Metacity theme from"
	ewarn "http://mso.fedorapeople.org/nodoka/nodoka-theme-gnome-0.3.1.2.tar.gz"
	ewarn
}
