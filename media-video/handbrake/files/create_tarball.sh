#!/bin/bash

REVISION=$1


setup() {
	TMP_DIR=`mktemp -d`
	SRC_DIR="${TMP_DIR}/source"
	mkdir -p "${SRC_DIR}"
	
	if [ -z "${REVISION}" ];then
		set_trunk_revision
	fi
	TARBALL_FILE="${TMP_DIR}/handbrake-revision-${REVISION}.tar.gz"
}

fetch_src() {
	svn checkout -r ${REVISION} svn://svn.handbrake.fr/HandBrake/trunk "${SRC_DIR}"
}

fetch_contrib() {
	cd "${SRC_DIR}"
	./configure --prefix=/usr
	cd ./build
	# http://trac.handbrake.fr/browser/trunk/doc/BUILD-Linux
	make contrib.fetch
}

create_tarball() {
	cd "${TMP_DIR}"
	tar -vzcf "${TARBALL_FILE}" ./source/
}

spit_divider_line() {
	echo "##############################################################################"
}

set_trunk_revision() {
	REVISION=$(svn info svn://svn.handbrake.fr/HandBrake/trunk | grep "Revision:" | cut -d " " -f 2)
}

main() {
	echo "Starting tarball build..."
	
	setup

	spit_divider_line
	echo "TMP_DIR: ${TMP_DIR}"
	echo "SRC_DIR: ${SRC_DIR}"
	echo "REVISION: ${REVISION}"
	spit_divider_line
	echo ""

	echo "fetching source..."
	fetch_src

	echo "fetching contrib files..."
	fetch_contrib

	echo "creating tarball..."
	create_tarball
	echo ""

	spit_divider_line
	echo "Congrats, ${TARBALL_FILE} has been successfully created"
	spit_divider_line
}

main
