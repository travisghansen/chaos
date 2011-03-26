# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib python

EAPI="1"

MY_P="$P"
MY_P="${MY_P/sab/SAB}"
MY_P="${MY_P/_beta/Beta}"
MY_P="${MY_P/_rc/RC}"


DESCRIPTION="Binary Newsgrabber written in Python, server-oriented using a web-interface.The active successor of the abandoned SABnzbd project."
HOMEPAGE="http://www.sabnzbd.org/"
SRC_URI="mirror://sourceforge/sabnzbdplus/${MY_P}-src.tar.gz"

HOMEDIR="${ROOT}var/lib/${PN}"
DHOMEDIR="/var/lib/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rar unzip rss +yenc ssl"

RDEPEND="
		>=dev-lang/python-2.4.4
		>=dev-python/pysqlite-2.3
		>=dev-python/celementtree-1.0.5
		>=dev-python/cherrypy-3.2.0_rc1
		>=dev-python/cheetah-2.0.1
		>=app-arch/par2cmdline-0.4
		rar? ( app-arch/rar )
		unzip? ( >=app-arch/unzip-5.5.2 )
		rss? ( >=dev-python/feedparser-4.1 )
		yenc? ( >=dev-python/yenc-0.3 )
		ssl? ( dev-python/pyopenssl )"
DEPEND="${RDEPEND}
		app-text/dos2unix"

S="${WORKDIR}/${MY_P}"
DOCS="CHANGELOG.txt ISSUES.txt INSTALL.txt README.txt"

src_unpack() {
	unpack ${A}
}

pkg_setup() {
	#Create group and user
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "${HOMEDIR}" "${PN}"
}

get_key() {
	local mypy len
	len=8
	mypy="import string;"
	mypy="$mypy from random import Random;"
	mypy="$mypy print ''.join(Random().sample(string.letters+string.digits, $len));"
	python -c "$mypy"
}

src_install() {
	api_key=$(get_key)
	ewarn "Setting api key to: $api_key"


	#Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	#Example config
	cd "${S}"
	cp  "${FILESDIR}/${PN}.ini" .
	sed -e "s/%API_KEY%/$api_key/g" -i "${PN}.ini"
	insinto /etc
	newins "${PN}.ini" "${PN}.conf"
	fowners root:${PN} /etc/${PN}.conf
	fperms 660 /etc/${PN}.conf
	fperms 660 /etc/conf.d/${PN}

	#Create all default dirs
	keepdir ${DHOMEDIR}

	for i in download dirscan complete nzb_backup cache scripts admin;do
		keepdir ${DHOMEDIR}/${i}
	done
	fowners -R ${PN}:${PN} ${DHOMEDIR}
	fperms -R 775 ${DHOMEDIR}

	keepdir /var/log/sabnzbd
	fowners -R ${PN}:${PN} /var/log/${PN}
	fperms -R 775 /var/log/${PN}

	#Add themes & code
	dodir /usr/share/${P}
	insinto /usr/share/${P}
	doins -r interfaces || die "installing interfaces"
	doins -r sabnzbd || die "installing sabnzbd directory"
	doins -r util || die "installing util directory"
	doins -r tools || die "installing tools directory"
	#doins -r cherrypy || die "installing sabnzbd directory"
	doins SABnzbd.py || die "installing SABnzbd.py"
	doins SABHelper.py || die "installing SABHelper.py"
	doins -r Sample-PostProc.* || die "installing postproc"

	#create symlink to keep the initial conf version free
	dosym /usr/share/${P} /usr/share/${PN}

	#fix permissions
	fowners -R root:sabnzbd /usr/share/${P}
	fperms -R 755 /usr/share/${P}

	# wrapper
	exeinto /usr/bin
	doexe "${FILESDIR}/SABnzbd"
}

pkg_postinst() {

	# optimizing
	python_mod_optimize /usr/share/${P}/sabnzbd

	einfo "Default directory: ${HOMEDIR}"
	einfo "Templates can be found in: ${ROOT}usr/share/${P}"
	einfo ""
	einfo "Run: gpasswd -a <user> sabnzbd"
	einfo "to add an user to the sabnzbd group so it can edit sabnzbd files"
	einfo ""
	ewarn "Please configure /etc/conf.d/${PN} before starting!"
	einfo ""
	einfo "Start with ${ROOT}etc/init.d/${PN} start"
	einfo "Default web credentials : sabnzbd/secret"
}

