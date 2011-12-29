# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="NSS module for name lookups using LDAP"
HOMEPAGE="http://arthurdejong.org/nss-pam-ldapd/"
SRC_URI="http://arthurdejong.org/nss-pam-ldapd/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug kerberos sasl"

DEPEND="net-nds/openldap
		sys-libs/pam
		sasl? ( dev-libs/cyrus-sasl )
		kerberos? ( virtual/krb5 )
		!sys-auth/pam_ldap
		!sys-auth/nss_ldap
		!sys-auth/nss-ldapd"
RDEPEND="${DEPEND}"

src_compile() {
	# nss libraries always go in /lib on Gentoo
	econf --enable-warnings --with-ldap-lib=openldap $(use_enable debug) \
		--libdir=/$(get_libdir) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc NEWS ChangeLog AUTHORS README

	# for socket and pid file
	keepdir /var/run/nslcd
	fowners nslcd:nslcd /var/run/nslcd

	# init script
	newinitd "${FILESDIR}"/nslcd.rc nslcd

	# make an example copy
	insinto /usr/share/nss-pam-ldapd
	doins nslcd.conf

	fperms o-r /etc/nslcd.conf
}

pkg_setup() {
	enewgroup nslcd
	enewuser nslcd -1 -1 /var/run/nslcd nslcd
}

pkg_postinst() {
	elog
	elog "For this to work you must configure /etc/nslcd.conf"
	elog "This configuration is similar to pam_ldap's /etc/ldap.conf"
	elog
	elog "In order to use nss-ldapd, nslcd needs to be running. You can"
	elog "start it like this:"
	elog "  # /etc/init.d/nslcd start"
	elog
	elog "You can add it to the default runlevel like so:"
	elog " # rc-update add nslcd default"
}
