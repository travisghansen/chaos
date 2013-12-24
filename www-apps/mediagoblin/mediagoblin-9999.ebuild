# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## LINKS
# http://www.linux-magazine.com/Online/Features/MediaGoblin
# http://mediagoblin.readthedocs.org/en/v0.5.1/
# http://wiki.mediagoblin.org/Deployment
# http://mediagoblin.readthedocs.org/en/latest/siteadmin/deploying.html

## TODO
# [[mediagoblin.media_types.stl]]
# requires blender >= 2.63

# [mediagoblin.media_types.pdf]]
# pdf.js bundled?
# expanded dep for headless libreoffice / unoconv

# [[mediagoblin.media_types.ascii]].
# requires dev-python/chardet

EAPI="5"
PYTHON_DEPEND="2"

inherit eutils git-2 python

DESCRIPTION="A media publishing platform that anyone can run."
HOMEPAGE="http://mediagoblin.org/"
EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-*"
IUSE=""

#python-imaging is requried as pillow does not currently work
#virtual/python-imaging
#dev-python/imaging

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
	dev-python/sphinx
	<dev-python/Babel-1.0
	virtual/python-argparse
	dev-python/configobj
	dev-python/markdown
	>=dev-python/sqlalchemy-0.8.0[sqlite]
	dev-python/itsdangerous
	dev-python/pytz
	dev-python/six
	=dev-python/oauthlib-0.5.0

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
	"

DEVDEPEND="
	<dev-python/webtest-2
	dev-python/pytest
	dev-python/mock
	dev-python/sqlalchemy-migrate
"

RDEPEND="${DEPEND}"

#S="${WORKDIR}/CouchPotatoServer"
DOCS="*.md"

pkg_setup() {
	enewgroup mediagoblin
	enewuser  mediagoblin -1 -1 /var/lib/mediagoblin mediagoblin
}

src_install() {
	keepdir "/var/lib/mediagoblin"
	dodir "/var/run/mediagoblin"
	dodir "/etc/mediagoblin"
	fowners mediagoblin:mediagoblin /var/lib/mediagoblin
	fowners mediagoblin:mediagoblin /var/run/mediagoblin
	fowners mediagoblin:mediagoblin /etc/mediagoblin

	#Init scripts
	#newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	#newinitd "${FILESDIR}/${PN}.init" "${PN}"

	dodir "/usr/share/couchpotato"
	cp -R * "${D}/usr/share/couchpotato/"
	
	cp ${FILESDIR}/settings.conf.sample "${D}/etc/couchpotato/"
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
	einfo "You must copy /etc/couchpotato/settings.conf.sample"
	einfo "to /etc/couchpotato/settings.conf and set the proper"
	einfo "permissions on the file as well"
	einfo ""
	einfo "cp /etc/couchpotato/settings.conf.sample /etc/couchpotato/settings.conf"
	einfo "chown couchpotato:couchpotato /etc/couchpotato/settings.conf"
}
