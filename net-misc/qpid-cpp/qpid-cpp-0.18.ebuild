# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.7"

inherit autotools-utils python

MY_D="qpidd"
MY_SPN="qpid"
MY_SP="${MY_SPN}-${PV}"

DESCRIPTION="A cross-platform Enterprise Messaging system which implements the Advanced Message Queuing Protocol"
HOMEPAGE="http://qpid.apache.org"
SRC_URI="mirror://apache/${MY_SPN}/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cluster doc sasl static-libs xml infiniband ssl swig test"

COMMON_DEP="cluster? ( sys-cluster/openais
				sys-cluser/cman-lib )
	>=dev-libs/boost-1.41.0-r3
	sasl? ( dev-libs/cyrus-sasl )
	xml? ( dev-libs/xerces-c
			dev-libs/xqilla[faxpp] )
	ssl? ( dev-libs/nss
			dev-libs/nspr )
	infiniband? ( sys-infiniband/libibverbs
				sys-infiniband/librdmacm )
	sys-apps/util-linux
	dev-libs/boost"

DEPEND="sys-apps/help2man
	test? ( dev-util/valgrind )
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}"
BDEPEND="dev-lang/ruby
	${DEPEND}"

S="${WORKDIR}/qpidc-${PV}"
DOCS=(DESIGN INSTALL README.txt RELEASE_NOTES SSL)
pkg_setup() {
	enewgroup ${MY_D}
	enewuser ${MY_D} -1 -1 -1 ${MY_D}

	python_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/swig-perl-bad-destdir.patch
}

# for reference
# http://pkgs.fedoraproject.org/cgit/qpid-cpp.git/tree/qpid-cpp.spec

src_configure() {
	local myeconfargs=(
		--without-help2man
		--disable-warnings
		$(use_with cluster cpg)
		$(use_with cluster libcman)
		$(use_with doc doxygen)
		$(use_with swig)
		$(use_with sasl)
		$(use_with xml)
		$(use_with infiniband rdma)
		$(use_with ssl)
		$(use_enable test valgrind) 
		--with-pic
		--localstatedir=/var
		--with-poller=epoll )
	autotools-utils_src_configure
}

src_install() {
	

	# parallel make install fails
	autotools-utils_src_install -j1
	rm "${D}"/etc/init.d/qpidd-primary

	newinitd "${FILESDIR}"/${MY_D}.init ${MY_D}
	newconfd "${FILESDIR}"/${MY_D}.conf ${MY_D}

	for dir in lib run ;do
		diropts -g ${MY_D} -o ${MY_D} -m 0750
		keepdir /var/${dir}/${MY_D}
	done

}
