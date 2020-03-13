#!/bin/sh
#
# Run a basic COBOL install/configure
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

zbrewpropse zbrew config ${mydir}/../../zbrew/zbrewglobalprops.json

# Clear up any jetsam from a previous run
zbrew uninstall igy630

drm -f "${ZBREW_SRC_HLQ}igy*.*"

zosinfo=`uname -rsvI`
version=`echo ${zosinfo} | awk '{ print $3; }'`
release=`echo ${zosinfo} | awk '{ print $2; }'`

case ${release} in
	'03.00' )
                export ZBREW_CEE230_CSI='MVS.GLOBAL.CSI'
		;;
	'04.00' )
                export ZBREW_CEE240_CSI='MVS.GLOBAL.CSI'
		;;
esac

#
# Add in the following once we get a base system with z/OS 2.4 
# installed (right now it will fail due to lack of PTFs installed)
#
zbrew install igy630
rc=$?
if [ $rc != 0 ]; then
	echo "zbrew install failed with rc:$rc" >&2
	exit 3
fi

zbrew configure igy630
rc=$?
if [ $rc != 0 ]; then
	echo "zbrew configure failed with rc:$rc" >&2
	exit 4
fi

# disabled this test for now ... have to update tests to read BOM to find mountpoints and verify
#bindir="${ZBREW_SRC_ZFSROOT}bin"
#if ! [ -d "${bindir}" ]; then
#	zbrewtest "leaf directory not created" "${bindir}" "${bindir}"
#	exit 6
#fi

exit 0
