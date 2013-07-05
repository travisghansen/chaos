# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefont-ttf/freefont-ttf-20090104.ebuild,v 1.4 2009/05/28 19:43:05 beandog Exp $

EAPI=5

inherit eutils

MY_PN="todo.txt"
MY_P="${MY_PN}_cli"

DESCRIPTION="If you want to get it done, first write it down."
HOMEPAGE="http://todotxt.com/"
SRC_URI="https://github.com/downloads/ginatrapani/${MY_PN}-cli/${MY_P}-${PV}.tar.gz"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"

IUSE=""

S="${WORKDIR}/${MY_P}-${PV}"

src_install(){
	mv todo.cfg todo.cfg.example
	exeinto /usr/bin
	doexe todo.sh
	dosym /usr/bin/todo.sh /usr/bin/t

	insinto /etc/todo
	doins todo.cfg.example

	insinto /usr/share/bash-completion
	doins todo_completion
}

pkg_postinst(){
	einfo "please copy /etc/todo/todo.cfg.example to ~/.todo/config"
	einfo "if you would like bash-completion to work with 't' then add the"
	einfo "following to your .bashrc:"
	einfo "complete -F _todo t"
}
