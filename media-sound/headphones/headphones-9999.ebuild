# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2:2.6"

inherit eutils git-2 python

MY_PN="${PN/s/S}"
MY_PN="${MY_PN/b/B}"

DESCRIPTION="Automatic music downloader for SABnzbd"
HOMEPAGE=="https://github.com/rembo10/headphones"
SRC_URI=""
EGIT_REPO_URI="https://github.com/rembo10/headphones.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="notify"

RDEPEND=""
DEPEND="${RDEPEND}
	notify? ( dev-python/notify-python )
	dev-python/cheetah"

DOCS=( "API_REFERENCE" "COPYING.txt" "README.md" "TODO" )

pkg_setup() {
	python_set_active_version 2
	enewgroup headphones
	enewuser  headphones -1 -1 -1 "headphones"
}

src_install() {
	# Init script
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	# Install
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}

	for hp_dir in cherrypy data lib mako headphones ; do
		doins -r ${hp_dir} || die "failed to install ${hp_dir}"
	done
	doins Headphones.py || die "failed to install Headphones.py"

	# Create run, log & cache directories
	for dir in cache lib log run ; do
		keepdir /var/${dir}/${PN}
		fowners -R headphones:headphones /var/${dir}/${PN}
		fperms -R 775 /var/${dir}/${PN}
	done

	# Install bare-bone config file
	keepdir /etc/${PN}
	insinto /etc/${PN}
	newins "${FILESDIR}/config.ini" "config.ini"
	fowners headphones:headphones /etc/${PN}/config.ini
	fperms 660 /etc/${PN}/config.ini
}

pkg_postinst() {
	python_mod_optimize "/usr/share/${PN}"
}

pkg_postrm() {
	python_mod_cleanup "/usr/share/${PN}"
}
