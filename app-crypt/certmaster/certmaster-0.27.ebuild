# Gentoo Portage ebuild for func, by Luca Lesinigo
# Distributed under the terms of the GNU General Public License v2
#
# this is pretty rough at the moment. it needs a look by someone who actually
# knows how to write ebuilds. But it's a start - it Works For Me :)

PYTHON_DEPEND=*

inherit distutils

DESRIPTION="A set of tools and a library for easily distributing SSL certificates to applications that need them"
HOMEPAGE="https://fedorahosted.org/certmaster/"
SRC_URI="https://fedorahosted.org/releases/c/e/certmaster/${P}.tar.gz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~hppa"

RDEPEND=">=dev-lang/python-2.3
         dev-python/pyopenssl"

PYTHON_MODNAME="certmaster"

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}"/certmaster-init.d certmaster
}

