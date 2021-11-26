#!/bin/bash

set -Eeuo pipefail

mkdir -p RPMS/x86_64 SRPMS BUILD BUILDROOT

BUILDER="${BUILDER:-centos-stream-8-x86_64}"

function build_pkg () {
  tmp_dir="$(mktemp -d -t mock-XXXXXXXXXX)"
  trap "rm -rf $tmp_dir" RETURN

  echo "========================================================="
  echo " Building $1 on $BUILDER"
  echo "========================================================="
  echo

  echo "Downloading sources and building srpm..."
  spectool -g -R SPECS/$1.spec
  rpmbuild -bs SPECS/$1.spec
  source_rpm="SRPMS/$(ls -1ct SRPMS | head -n1)"
  echo "Successfully generated $source_rpm!"
  echo

  echo "Compiling..."
  # To debug, add "-nN"
  mock -r "$BUILDER" --resultdir="$tmp_dir" ${EXTRA_PARAMS:-} "$source_rpm"
  echo
  
  echo "Cleaning up..."
  rm -f $tmp_dir/*.src.rpm $tmp_dir/*.log
  mv $tmp_dir/*.rpm RPMS/x86_64/
  echo
}

function build_custom_pkg () {
  pkg="$(basename "$spec")"
  pkg="${pkg%.spec}"
  (test -f "MOCKCONFIG/$pkg.cfg" && . "MOCKCONFIG/$pkg.cfg" ; build_pkg "$pkg")
}

if [ $# -gt 0 ]; then
  for spec; do
    build_custom_pkg "$spec"
  done
else
  for spec in SPECS/*.spec; do
    build_custom_pkg "$spec"
  done
fi

