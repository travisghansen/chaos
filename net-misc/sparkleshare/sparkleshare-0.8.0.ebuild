# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"

WANT_AUTOMAKE="1.11"

inherit base eutils mono python

DESCRIPTION="SparkleShare is a file sharing and collaboration tool inspired by Dropbox"
HOMEPAGE="http://www.sparkleshare.org"
SRC_URI="http://github.com/downloads/hbons/SparkleShare/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
SLOT="0"
IUSE="doc nautilus"

DOCS=("NEWS" "AUTHORS")

DEPEND=">=dev-lang/mono-2.2
		>=dev-dotnet/gtk-sharp-2.12.7
		>=dev-dotnet/ndesk-dbus-0.6
		>=dev-dotnet/ndesk-dbus-glib-0.4.1
		>=dev-dotnet/webkit-sharp-0.3
		nautilus? ( || ( ( >=dev-python/nautilus-python-1.1
						   >=gnome-base/nautilus-3.2.0[introspection]
						   >=dev-libs/gobject-introspection-1.30.0-r1
						   x11-libs/gtk+:3[introspection]
						 )
						 ( <dev-python/nautilus-python-1.1
						   <=gnome-base/nautilus-3
						 )
				       )
				  )
		doc? ( >=app-text/gnome-doc-utils-0.17.3 )"
RDEPEND="${DEPEND}
		 >=dev-vcs/git-1.7
		 net-misc/openssh
		 >=gnome-base/gvfs-1.3
		 dev-util/intltool
		 x11-misc/xdg-utils"

src_configure() {
	base_src_configure $(use_enable nautilus nautilus-extension) \
	  $(use_enable doc user-help)
}

src_compile() {
	emake || die "make failed"
}

pkg_postinst() {
	python_mod_optimize /usr/share/nautilus-python/extensions/
}

pkg_postrm() {
	python_mod_cleanup /usr/share/nautilus-python/extensions/
}
