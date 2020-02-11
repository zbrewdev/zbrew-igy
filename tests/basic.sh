#!/bin/sh
#
# Run a basic COBOL install/configure
#
. zbrewfuncs
mydir=$(callerdir ${0})
#set -x

zbrewpropse zbrew config ${mydir}/../../zbrew/properties/zbrewprops.json
zbrewpropse igy630 install ${mydir}/../igy630/igy630install.json

# Clear up any jetsam from a previous run
MOUNT="${ZFSROOT}${ZFSDIR}"
unmount "${MOUNT}" 2>/dev/null 

drm -f "${ZBREW_HLQ}igy*.*"

zosinfo=`uname -rsvI`
version=`echo ${zosinfo} | awk '{ print $3; }'`
release=`echo ${zosinfo} | awk '{ print $2; }'`

case ${release} in
	'03.00' )
                export CEE230_CSI='MVS.GLOBAL.CSI'
		;;
	'04.00' )
                export CEE240_CSI='MVS.GLOBAL.CSI'
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

bindir="${MOUNT}bin"
if ! [ -d "${bindir}" ]; then
	zbrewtest "leaf directory not created" "${bindir}" "${bindir}"
	exit 6
fi

exit 0
