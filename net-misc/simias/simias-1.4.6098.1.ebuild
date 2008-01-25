
# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
inherit mono

BUILDDATE="20060408-0212/"

DESCRIPTION="Simias SimpleServer"
HOMEPAGE="http://www.ifolder.com/"
SRC_URI="http://forgeftp.novell.com/ifolder/client/3.4/${BUILDDATE}/src/${P}.tar.gz"

IUSE="simpleserver"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND=">=dev-lang/mono-1.0
	>=dev-dotnet/log4net-1.2.9
	>=net-libs/libflaim-4.8.61
	!dev-dotnet/ifolder-server"



simiasdatadir="${ROOT}var/lib/simias"

src_unpack() {
	unpack ${A} || die "Error unpacking ${PN}"
	cd ${S} || die "Error entering ${PN} source directory"
	epatch ${FILESDIR}/webdir-prefix.patch
	epatch ${FILESDIR}/SimiasSetup.cs.in.patch
}

src_compile() {
	local myconf

	sed -i -e "s|@_simiasdatadir_@|${simiasdatadir}|g" ${S}/other/SimpleServer/simpleserver.in || die "Error patching simpleserver.in"
	myconf="--sysconfdir=${ROOT}etc/simias --with-simiasdatadir=${simiasdatadir}"
	econf ${myconf}
	emake

}

src_install() {
	make DESTDIR=${D} install

	if use simpleserver;then
		cd other/SimpleServer
		make DESTDIR=${D} install-simpleserver || die "Error installing simpleserver"
		doinitd ${FILESDIR}/ifolder || die "Error installing ifolder init script from ${FILESDIR}"
		if [[ ! -d ${simiasdatadir} ]];then
			ewarn "Creating ${simiasdatadir}"
			dodir ${simiasdatadir}
		fi
	fi

}

pkg_preinst() {

	if use simpleserver;then
		test -x ${FILESDIR}/ifolder || die "Missing ifolder init script from ${FILESDIR}"
	fi

}


pkg_postinst() {

	if use simpleserver;then
		einfo ""
		einfo "SimpleServer has been installed."
		einfo "Please edit ${ROOT}/etc/simias/SimpleServer.xml to suit your needs."
		einfo ""
		einfo "An init script has also been installed to start and stop the"
		einfo "SimpleServer process.  /etc/init.d/ifolder"
		einfo "If you would like to start SimpleServer on boot-up please run"
		einfo "rc-update add ifolder default"
		einfo ""
		einfo "Point your clients to simpleserver:8086"
		einfo ""
	fi
		
}
