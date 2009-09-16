# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="DB-Based Kannel Box for message queueing"
HOMEPAGE="http://www.kannel.org/~aguerrieri/SqlBox/"
SRC_URI="http://www.kannel.org/~aguerrieri/SqlBox/Releases/${P}.tar.gz"

LICENSE="Kannel"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mysql sqlite postgres ssl doc"

DEPEND="app-mobilephone/kannel
	ssl? ( >=dev-libs/openssl-0.9.8d )
	mysql? ( app-mobilephone/kannel[mysql] )
	sqlite? ( app-mobilephone/kannel[sqlite] )
	postgres? ( app-mobilephone/kannel[postgres] )
	doc? ( media-gfx/transfig
		app-text/jadetex
		app-text/docbook-dsssl-stylesheets )"
RDEPEND="${DEPEND}"

src_prepare() {

	epatch ${FILESDIR}/sqlbox-0.7.2-sqlinit-hfiles.patch

}

src_configure() {

	./bootstrap || die "failed running bootstrap"

	econf --docdir=/usr/share/doc/${P} \
		--without-ctlib \
		--without-mssql \
		$(use_enable ssl) \
		$(use_enable doc docs) \
		$(use_enable doc drafts) \
		|| die "econf failed"

}

src_install() {
	emake DESTDIR="${D}" install || die "failed emake install"

#	disabling due to some silly errors
#	if use doc; then
#		emake DESTDIR="${D}" docs || die "emake docs failed"
#	fi


	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README UPGRADE
	insinto /etc/kannel
	newins example/sqlbox.conf.example sqlbox.conf.sample

}
