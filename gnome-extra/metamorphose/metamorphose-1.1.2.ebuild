# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme/tango-icon-theme-0.7.2.ebuild,v 1.3 2006/06/02 12:51:20 corsair Exp $

DESCRIPTION="A File -n- Folder Renamer"
HOMEPAGE="http://file-folder-ren.sourceforge.net/index.php?page=Main"
SRC_URI="http://downloads.sourceforge.net/file-folder-ren/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="dev-python/pygtk
	dev-python/wxpython"

DEPEND="${RDEPEND}"

src_compile() {

	einfo "Nothing to do"

}

src_install() {
	

	emake makedirs DESTDIR="${D}" || die "Failed compiling"
	emake build DESTDIR="${D}" || die "Failed compiling"

	emake install DESTDIR="${D}" || die "Failed installing"
	
}
