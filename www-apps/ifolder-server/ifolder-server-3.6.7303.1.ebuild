# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils mono

BUILDDATEANDTIME="20070103-0142"

DESCRIPTION="Enterprise backend for iFolder"
HOMEPAGE="http://www.ifolder.com/"
SRC_URI="http://distfiles.one-gear.com/distfiles/ifolder${PV:0:1}-server-${PV}.tar.gz
		http://superb-east.dl.sourceforge.net/sourceforge/gsoap2/gsoap-linux-2.7.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
RESTRICT="mirror"

DEPEND="!net-misc/simias
		>=dev-lang/mono-1.2.1
		>=dev-db/libflaim-4.9.617
		>=dev-dotnet/log4net-1.2.9
		>=www-apache/mod_mono-1.2.1
		sys-fs/e2fsprogs"
RDEPEND="${DEPEND}"

#S=${WORKDIR}/ifolder${PV:0:1}-server-${PV}
S=${WORKDIR}/simias
	
simiasdatadir="${ROOT}var/lib/simias"
gentoo_config_dir="${ROOT}etc/simias/apache/gentoo"
logdir="${ROOT}var/log/ifolder3"
DEVNULL=/dev/null

src_unpack() {

	unpack ${A}
	cd ${S}
	#Patch the path of mod_mono.conf
#	epatch ${FILESDIR}/${PN}-mod_mono-path.patch
	epatch ${FILESDIR}/gsoap-path.patch
	epatch ${FILESDIR}/gsoap-compile-new.patch
#	epatch ${FILESDIR}/${PN}-apache-rights.patch
#	epatch ${FILESDIR}/${PN}-simias-server-setup.patch

	
	epatch ${FILESDIR}/new_mod_mono.diff
	epatch ${FILESDIR}/ifolder-admin-setup.diff
	epatch ${FILESDIR}/ifolder-apache-conf.diff
	epatch ${FILESDIR}/ifolder-web-setup.diff
	epatch ${FILESDIR}/simias-server-setup.diff
	epatch ${FILESDIR}/no_write_to_etc_during_install.diff
	epatch ${FILESDIR}/new_default_simias.config.diff
#	epatch ${FILESDIR}/flex_in_lib64.diff
#	epatch ${FILESDIR}/${PN}-simias-server-setup.patch


}

src_compile() {

	local myconf
	myconf="--with-runasserver --with-simiasdatadir=${simiasdatadir}"
	./autogen.sh ${myconf}
#	eautoreconf
	econf ${myconf}
	mv ${WORKDIR}/gsoap-linux-2.7 ${S}/tools/gsoap/
	make DESTDIR={$D} || die "Error compiling ${PN}"

}

src_install() {

	make DESTDIR=${D} install || die "Error install ${PN}"	
	dodir "${simiasdatadir}"
	keepdir "${simiasdatadir}"
#	dodir "${logdir}"
#	keepdir "${logdir}"
	dodir "${gentoo_config_dir}"

#	if [[ ! -f ${simiasdatadir}/Simias.config ]];then
#		einfo "It appears you have never setup iFolder"
#		einfo "Extracting setup-files to ${simiasdatadir}"
#		tar -zxvf ${FILESDIR}/setup-files.tar.gz -C ${D}/${simiasdatadir}
#	fi

}

pkg_postinst() {


	echo ""	
	ewarn "Please edit ${ROOT}etc/apache2/httpd.conf and add the following line"
	ewarn "at the bottom of the file after Include ${ROOT}etc/apache2/vhosts.d/*.conf"
	ewarn "Include /etc/simias/apache/*.conf"
	echo ""
	ewarn "You MUST add \"-D MONO\" to APACHE2_OPTS in /etc/conf.d/apache2"
	echo ""
#	ewarn "You can check by running ps aux | grep mono"
#	ewarn "Remember, your default admin credentials are:  admin:novell"
	echo ""
	ewarn "You must run emerge --config ifolder-server now"
	ewarn "to complete the install if this is the first time"
	ewarn "you have installed the server"
#	ewarn "Please edit ${simiasdatadir}/Simias.config now to change your administrative"
#	ewarn "username and password if desired and to set the name and description of your new iFolder server."
#	ewarn "You must also edit the \"PublicAddress\" and \"PrivateAddress\""
#	ewarn "settings to match your environment!"
	echo ""
	ewarn "Visit http://www.ifolder.com/index.php/HowTo:Building_iFolder_Enterprise_Server_on_Gentoo"
	ewarn "for more information"
#	echo ""
#	ewarn "Please login to http://localhost/admin/ in order to initialize the db"
#	ewarn "if this is the first time running the server"

}

pkg_config(){

	ewarn "Remember that ${PN} runs behind apache"
	ewarn "therefore give appropriate urls when running this"
	ewarn "script.  Specifically with regards to ports"
	ewarn "ie: use \"http://localhost\""
	ewarn "do not use \"http://localhost:8086\""
	echo ""

	simias-server-setup --apache --path=${simiasdatadir} --prompt
	chown -R apache:apache "${simiasdatadir}"

	ifolder-admin-setup
	ifolder-web-setup

	echo ""
	einfo "Congratulations, configuration complete!"
	ewarn "Now login to http://<server>/admin/"
	ewarn "to initialize the database and create users"
	ewarn "if this is the first time running the server"
	ewarn "After you have created users you can login"
	ewarn "to the web interface by visiting"
	ewarn "http://<server>/ifolder/"
	echo ""
	ewarn "Do NOT use epiphany"

}
