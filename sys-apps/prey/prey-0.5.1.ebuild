# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Tracking software for asset recovery"
HOMEPAGE="http://preyproject.com/"
SRC_URI="http://preyproject.com/releases/${PV}/${P}-linux.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk"
IUSE_MODULES="alarm +alert +geo +lock +network +secure +session +system webcam"
IUSE="${IUSE} ${IUSE_MODULES}"

DEPEND=""
#TODO: some of these deps may be dependent on USE
RDEPEND="${DEPEND}
	app-shells/bash
	virtual/cron
	|| ( net-misc/curl net-misc/wget )
	dev-perl/IO-Socket-SSL
	dev-perl/Net-SSLeay
	sys-apps/net-tools
	alarm? ( media-sound/mpg123
			 media-sound/pulseaudio
		   )
	alert? ( || ( ( gnome-extra/zenity ) ( kde-base/kdialog ) ) )
	gtk? ( dev-python/pygtk )
	lock? ( dev-python/pygtk )
	network? ( net-analyzer/traceroute )
	session? ( sys-apps/iproute2
			   || ( media-gfx/scrot media-gfx/imagemagick )
			 )
	system? ( sys-apps/hal )
	webcam? ( || ( ( media-video/mplayer[encode,jpeg,v4l2] ) ( media-tv/xawtv ) ) )"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch ${FILESDIR}/${P}-functions.patch
	epatch ${FILESDIR}/${P}-config-path-fix.patch
	epatch ${FILESDIR}/${P}-mplayer-support.patch
}

src_compile() {
	:
}

src_install() {
	# Remove config app if -gtk
	use gtk || rm -f platform/linux/prey-config.py

	# Core files
	dodir /usr/share/prey
	cp -a core lang pixmaps platform version prey.sh "${D}/usr/share/prey"

	# fix the path
	dosed 's,readonly base_path=`dirname "$0"`,readonly base_path="/usr/share/prey",' /usr/share/prey/prey.sh

	# Put the configuration file into /etc, strict perms, symlink
	insinto /etc/prey
	mv config prey.conf
	mv config.default prey.conf.sample
	doins prey.conf
	doins prey.conf.sample
	fperms 700 /etc/prey
	fperms 600 /etc/prey/prey.conf
	fperms 600 /etc/prey/prey.conf.sample
	dosym /etc/prey/prey.conf /usr/share/prey/config

	# Add cron.d script
	insinto /etc/cron.d
	doins "${FILESDIR}/prey.cron"
	fperms 600 /etc/cron.d/prey.cron

	# modules
	cd modules
	for mod in *
	do
		use ${mod} || continue

		# Rest of the module in its expected location
		insinto /usr/share/prey/modules
		doins -r "$mod"
		fperms 500 "/usr/share/prey/modules/${mod}/core/run"

		# if present symlink module config to /etc/prey
		if [ -f "$mod/config" ];then
			mv "$mod/config" "mod-$mod.conf"
			insinto "/etc/prey"
			doins "mod-$mod.conf"
			fperms 600 "/etc/prey/mod-$mod.conf"
			dosym "/etc/prey/mod-$mod.conf" "/usr/share/prey/modules/$mod/config"
			if [ "${mod}" == "lock" ];then
				fperms 555 \
				  "/usr/share/prey/modules/lock/platform/linux/prey-lock"
			fi
		fi

	done

	dodoc "${S}/README" "${S}/LICENSE"

}

pkg_postinst () {
	einfo "To run prey, modify core and module configuration in /etc/prey,"
	einfo "then uncomment the line in /etc/cron.d/prey.cron"
}
