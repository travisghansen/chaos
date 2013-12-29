# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## LINKS
# http://www.linux-magazine.com/Online/Features/MediaGoblin
# http://mediagoblin.readthedocs.org/en/v0.5.1/
# http://wiki.mediagoblin.org/Deployment
# http://mediagoblin.readthedocs.org/en/latest/siteadmin/deploying.html
# http://mediagoblin.readthedocs.org/en/latest/siteadmin/media-types.html

## TODO
# [[mediagoblin.media_types.stl]]
# requires blender >= 2.63

# [[mediagoblin.media_types.pdf]]
# pdf.js bundled?
# expanded dep for headless libreoffice / unoconv

# [[mediagoblin.media_types.ascii]]
# requires dev-python/chardet
# may require media-fonts/inconsolata

EAPI="5"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="A media publishing platform that anyone can run."
HOMEPAGE="http://mediagoblin.org/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#python-imaging is requried as pillow does not currently work
#virtual/python-imaging
#dev-python/imaging

# pytest-xdist
# argparse

# this is a fuster
#	>=dev-python/sqlalchemy-0.8.0[sqlite]
#	dev-python/sqlalchemy-migrate

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
	virtual/python-argparse
	dev-python/configobj
	dev-python/markdown
	dev-python/itsdangerous
	dev-python/pytz
	dev-python/six
	=dev-python/oauthlib-0.5.0

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


src_install() {
	distutils_src_install
	rm ${D}/usr/bin/pybabel
}

pkg_postinst() {
	#gmg adduser thansen
	#gmg makeadmin thansen
	#gmg changepw thansen
	#einfo "foo"
	# background worker using
	# ./lazycelery.sh in data directory
	:
}
