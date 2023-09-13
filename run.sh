#!/bin/sh

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/

# TODO: download to SCRIPTDIR
rm -rf 2.8.tar.gz cppcheck-2.8
wget https://github.com/danmar/cppcheck/archive/refs/tags/2.8.tar.gz
tar xvf 2.8.tar.gz

# TODO: add dump files
# TODO: add remaining options from selfcheck
options="-q -D__GNUC__ --debug"

outdir="$SCRIPTDIR/compare-out"
rm -rf $outdir

FILESBASE="cppcheck-2.8"
FILES="$FILESBASE/externals/simplecpp/*.cpp $FILESBASE/cli/*.cpp $FILESBASE/lib/*.cpp $FILESBASE/gui/*.cpp $FILESBASE/test/*.cpp $FILESBASE/tools/*.cpp $FILESBASE/tools/triage/*.cpp"
# TODO: parallilize loop
for f in $FILES
do
  outfile="$outdir/$f.out"
  mkdir -p $(dirname $outfile)
  echo $f
  ./cppcheck $options $f > $outfile
  datafile="$SCRIPTDIR/compare-data/$f.out"
  if [ -f $datafile ]; then
    diff -u $datafile $outfile
  else
    echo "no reference data for $f"
  fi
done

rm -rf 2.8.tar.gz cppcheck-2.8