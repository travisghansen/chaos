# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Comprehensive, high performance, small footprint multimedia
communication libraries written in C language for building embedded/non-embedded
VoIP applications."
HOMEPAGE="http://www.pjsip.org/"
SRC_URI="http://www.pjsip.org/release/${PV}/pjproject-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="epoll oss libsamplerate ipp g711 l16 gsm g722 g7221
speex ilbc alsa ext-sound python doc examples"
#small-filter large-filter speex-aec ssl

DEPEND="gsm? ( media-sound/gsm )
	speex? ( media-libs/speex )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	alsa? ( media-libs/alsa-lib )"
	#ssl? ( dev-libs/openssl )
RDEPEND="${DEPEND}"

S="${WORKDIR}/pjproject-${PV}"

src_prepare() {
	#remove target name from lib names
	sed -i -e 's/-$(TARGET_NAME)//g' \
		-e 's/= $(TARGET_NAME).a/= .a/g' \
		-e 's/-$(LIB_SUFFIX)/$(LIB_SUFFIX)/g' \
		$(find . -name '*.mak*' -o -name Makefile) || die "sed failed."

	#fix hardcoded prefix and flags
	sed -i \
		-e 's/poll@/poll@\nexport PREFIX := @prefix@\n/g' \
		-e 's!prefix = /usr/local!prefix = $(PREFIX)!' \
		-e '/PJLIB_CFLAGS/ s/(_CFLAGS)/(_CFLAGS) -fPIC/g' \
		-e '/PJLIB_UTIL_CFLAGS/ s/(_CFLAGS)/(_CFLAGS) -fPIC/g' \
		Makefile \
		build.mak.in || die "sed failed."

	#disable symlinking (lib-target_name to lib)
	sed -i -e '/cd \$/b1;b;:1 N;N;d' \
		Makefile || die "sed failed."

	#TODO: remove deps to shipped codecs and libs, use system ones
	#rm -r third_party
	#libresample: https://ccrma.stanford.edu/~jos/resample/Free_Resampling_Software.html
}

src_configure() {
	#disable through portage available codecs
	econf --disable-gsm-codec \
		--disable-speex-codec \
		--disable-ilbc-codec \
		--disable-speex-aec \
		$(use_enable epoll) \
		$(use_enable alsa sound) \
		$(use_enable oss) \
		$(use_enable ext-sound) \
		$(use_enable g711 g711-codec) \
		$(use_enable l16 l16-codec) \
		$(use_enable g722 g722-codec) \
		$(use_enable g7221 g7221-codec) || die "econf failed."
		#$(use_enable small-filter) \
		#$(use_enable large-filter) \
		#$(use_enable speex-aec) \
		#$(use_enable ssl) \ #broken? sflphone doesn't compile if enabeld or disabled
}

src_compile() {
	emake dep || die "emake dep failed."
	emake -j1 || die "emake failed."
}

src_install() {
	DESTDIR="${D}" emake install || die "emake install failed."

	if use python; then
		pushd pjsip-apps/src/py_pjsua
		python setup.py install --prefix="${D}/usr/"
		popd
	fi

	if use doc; then
		dodoc COPYING README.txt README-RTEMS INSTALL.txt
	fi

	if use examples; then
		insinto /usr/share/doc/${P}/examples
		doins ${S}/pjsip-apps/src/samples/*
	fi

	#remove files that pjproject should not install
	rm -r ${D}/usr/lib/libportaudio.a \
		${D}/usr/lib/libsrtp.a \
		${D}/usr/include/err.h \
		${D}/usr/include/portaudio.h \
		${D}/usr/include/speex
}
