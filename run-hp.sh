#!/bin/bash
set -e

echo "THIS IS A SAMPLE."
echo "You'll have to modify this to work in your environment"
exit 1

#
# Very Rough sample code for running hphp for analysis
#

# This is where the final HpHp code lives
export HPHP_HOME=/usr/local/hphp-root
export PATH=$PATH:${HPHP_HOME}/bin
export HPHP_TMP=/tmp/hphp
export JUNK=${HPHP_TMP}/junk.txt

# where your source code is
export SOURCE=~/Your/Source/Directory

# create tmp directory
if [ ! -d "${HPHP_TMP}" ]; then
  mkdir ${HPHP_TMP}
fi

# remove old HpHp output
rm -rf ${HPHP_TMP}/CodeError.js ${HPHP_TMP}/Stats.js

#
# Create a list of files to analyze
#

# create your constants.php using
# /usr/local/hphp-root/bin/gen_constants.php
# and edit as needed
cp ~/constants.php ${HPHP_TMP}/constants.php
echo "${HPHP_TMP}/constants.php" > $JUNK

#
# your stub file, if any
#
cp ~/hphp_stubs.php.txt ${HPHP_TMP}/hphp_stubs.php
echo "${HPHP_TMP}/hphp_stubs.php" >> $JUNK

# copy in special HpHp system files
# helper.idl.php isn't valid PHP
# constants.php conflicts with your hand-made version
find ${HPHP_ROOT}/system/ -name '*.inc' -o -name '*.php' | \
    grep -v  helper.idl.php | grep -v constants.php >> $JUNK

cd ${SOURCE}
find phplib -name '*.php' >> $JUNK
# add other find calls for more files >> $JUNK

#
# remove any test files
#
grep -v Test $JUNK > ${HPHP_TMP}/files.txt

# do it
echo "Running hphp..."
hphp --input-list ${HPHP_TMP}/files.txt \
    --log 2 \
    --include-path "${SOURCE}"
    -t analyze  \
    --output-dir ${HPHP_TMP} 2>&1 | grep -v 'Unable to stat file'


echo "See ${HPHP_TMP}/CodeError.js for details! "
exit 0
