# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## LINKS
# http://www.linux-magazine.com/Online/Features/MediaGoblin
# http://mediagoblin.readthedocs.org/en/v0.5.1/
# http://wiki.mediagoblin.org/Deployment
# http://mediagoblin.readthedocs.org/en/latest/siteadmin/deploying.html
# http://mediagoblin.readthedocs.org/en/latest/siteadmin/media-types.html
# http://mediagoblin.readthedocs.org/en/v0.6.1/siteadmin/commandline-upload.html

## TODO
# [[mediagoblin.media_types.stl]]
# requires blender >= 2.63

# [[mediagoblin.media_types.pdf]]
# pdf.js bundled?
# expanded dep for headless libreoffice / unoconv

# [[mediagoblin.media_types.ascii]]
# requires dev-python/chardet
# may require media-fonts/inconsolata

## TODO
# > 0.6.1
# will require >=Bable-1.0
# will require ExifRead
# will require more craziness with sqlalchemy

EAPI="5"
PYTHON_DEPEND="2"

inherit distutils user

DESCRIPTION="A media publishing platform that anyone can run."
HOMEPAGE="http://mediagoblin.org/"

if [[ ${PV} = *9999* ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
	KEYWORDS="-*"
else
	SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE=""

# pytest-xdist
# argparse

DEPEND=">=dev-lang/python-2.7[sqlite]
    dev-db/sqlite
	dev-python/lxml
	virtual/python-imaging
	<dev-python/kombu-3
	dev-python/pastescript
	dev-python/wtforms
	dev-python/py-bcrypt
	dev-python/werkzeug
	dev-python/celery
	dev-python/jinja
	dev-python/mock
	<dev-python/Babel-1.0
	dev-python/configobj
	dev-python/markdown
	dev-python/itsdangerous
	dev-python/pytz
	dev-python/six
	=dev-python/oauthlib-0.5.0
	>=dev-python/sqlalchemy-0.9.0[sqlite]
	>=dev-python/sqlalchemy-migrate-0.9

    dev-python/flup
    dev-python/numpy

	media-libs/gstreamer:0.10
	media-libs/gst-plugins-good:0.10
	media-libs/gst-plugins-bad:0.10
	media-libs/gst-plugins-ugly:0.10
	media-plugins/gst-plugins-ffmpeg:0.10
	media-plugins/gst-plugins-vp8:0.10
	media-plugins/gst-plugins-vorbis:0.10
	media-plugins/gst-plugins-twolame:0.10
	dev-python/pygobject:2
	dev-python/gst-python
	
	app-text/poppler[cairo,utils]
	dev-python/pycairo

	dev-python/audiolab
	media-plugins/gst-plugins-ogg


	<dev-python/webtest-2
	"

DEVDEPEND="
	<dev-python/webtest-2
	dev-python/pytest
	dev-python/mock
	dev-python/sphinx
"

# not sure which of these are really used
# but in order to be useful extremely full
# codec support is required
CODECDEPEND="
	media-plugins/gst-plugins-lame:0.10
	media-plugins/gst-plugins-x264:0.10
	media-plugins/gst-plugins-xvid:0.10
	media-plugins/gst-plugins-wavpack:0.10
	media-plugins/gst-plugins-theora:0.10
	media-plugins/gst-plugins-mpeg2dec:0.10
	media-plugins/gst-plugins-a52dec:0.10
	media-plugins/gst-plugins-alsa:0.10
	media-plugins/gst-plugins-dts:0.10
	media-plugins/gst-plugins-dv:0.10
	media-plugins/gst-plugins-faac:0.10
	media-plugins/gst-plugins-faad:0.10
	media-plugins/gst-plugins-flac:0.10
	media-plugins/gst-plugins-gsm:0.10
	media-plugins/gst-plugins-jpeg:0.10
	media-plugins/gst-plugins-libpng:0.10
	media-plugins/gst-plugins-mimic:0.10
	media-plugins/gst-plugins-musepack:0.10
	media-plugins/gst-plugins-neon:0.10
	media-plugins/gst-plugins-opus:0.10
	media-plugins/gst-plugins-raw1394:0.10
	media-plugins/gst-plugins-rtmp:0.10
	media-plugins/gst-plugins-speex:0.10
"

CODECOTHERS="
	media-plugins/gst-plugins-libmms:0.10
	media-plugins/gst-plugins-libnice:0.10
	media-plugins/gst-plugins-libvisual:0.10
	media-plugins/gst-plugins-timidity:0.10
"

RDEPEND="${DEPEND} ${DEVDEPEND} ${CODECDEPEND}"

pkg_setup() {
    enewgroup ${PN}
    enewuser ${PN} -1 /bin/bash /var/lib/${PN} ${PN}
	python_pkg_setup
}

src_install() {
	distutils_src_install
	rm ${D}/usr/bin/pybabel
	keepdir /var/lib/${PN}
	dodir /var/log/${PN}

	# copy stock ones over as samples
	for file in mediagoblin.ini paste.ini;do
		cp ${file} "${D}"/var/lib/${PN}/${file:-4}.sample.ini
	done
	
	# copy lazystarter.sh into place and create symlinks
	cp "lazystarter.sh" "${D}"/var/lib/${PN}/lazystarter.sh
	cd "${D}"/var/lib/${PN}/
	ln -sf lazystarter.sh lazycelery.sh
	ln -sf lazystarter.sh lazyserver.sh
	cd "${S}"

	dodoc README
	
	# this is bogus on purpose
	# create a gentoo-y mediagoblin.ini
	sed -e "s|@BOGUS@|@BOGUS@|" \
		"${FILESDIR}"/mediagoblin.template.ini > "${D}"/var/lib/${PN}/mediagoblin.ini \
		|| die "failed to create mediagoblin.ini"
	
	# create gentoo-y paste.ini
	sed -e "s|@INSTALL_DIR@|/usr/lib64/python2.7/site-packages|" \
		"${FILESDIR}"/paste.template.ini > "${D}"/var/lib/${PN}/paste.ini \
		|| die "failed to create paste.ini"
	
	echo "CONFIG_PROTECT=\"/var/lib/${PN}\"" > 99mediagoblin
	doenvd 99mediagoblin
	
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	chown -R "${PN}:${PN}" ${D}/var/lib/${PN}
	chown -R "${PN}:${PN}" ${D}/var/log/${PN}
}

pkg_config() {
	einfo "Performing DB Update..."
	su - mediagoblin -c "gmg dbupdate"
}

pkg_postinst() {
	python_mod_optimize ${PN}
	
	elog
	elog "1. Edit /var/lib/${PN}/mediagoblin.ini to your needs"
	elog "2. Edit /var/lib/${PN}/paste.ini to your needs"
	elog
	elog "3. emerge --config \"=${CATEGORY}/${PF}\""
	elog

	einfo "use 'gmg adduser -u myuser' to create an account"
	einfo "use 'gmg makeadmin myuser' to create an admin'"
	einfo "use 'gmg changepw myuser' to change an account password"
}
