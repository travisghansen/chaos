# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_AUTOMAKE="1.11"

inherit eutils mono

DESCRIPTION="SparkleShare is a file sharing and collaboration tool inspired by Dropbox"
HOMEPAGE="http://www.sparkleshare.org"
SRC_URI="http://github.com/downloads/hbons/SparkleShare/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="nautilus"

#MY_PV="${PV/_beta/-beta}"
#MY_P="${PN}-${MY_PV}"

#SRC_URI="http://www.sparkleshare.org/${MY_P}.tar.gz"

DEPEND=">=dev-lang/mono-2.2
		>=dev-dotnet/gtk-sharp-2.12.7
		>=dev-dotnet/ndesk-dbus-0.6
		>=dev-dotnet/ndesk-dbus-glib-0.4.1
		>=dev-dotnet/webkit-sharp-0.3
		nautilus? ( dev-python/nautilus-python )"
RDEPEND="${DEPEND}
		>=dev-vcs/git-1.7
		net-misc/openssh
		>=gnome-base/gvfs-1.3
		dev-util/intltool"

#S="${WORKDIR}/sparkleshare-0.2-rc1"

src_install() {
	emake install DESTDIR=${D} || die "error installing"
}
