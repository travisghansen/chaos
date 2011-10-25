# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtk-sharp/gtk-sharp-2.12.10.ebuild,v 1.4 2010/09/12 04:27:51 josejx Exp $

EAPI="2"

inherit eutils git-2

SLOT="3"
KEYWORDS="-*"
IUSE=""
EGIT_REPO_URI="git://github.com/mono/gtk-sharp.git"
EGIT_BOOTSTRAP="autogen.sh"

RESTRICT="test"

src_install() {
	emake install DESTDIR="${D}"
}
