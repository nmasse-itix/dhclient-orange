#!/bin/bash

set -Eeuo pipefail

mkdir -p RPMS/x86_64 SRPMS BUILD BUILDROOT
tmp_dir="$(mktemp -d -t mock-XXXXXXXXXX)"
trap "rm -rf $tmp_dir" EXIT

# List of available builders: ls -1 /etc/mock
builder="${BUILDER:-centos-stream-8-x86_64}"
echo "Using builder image $builder..."

function build_pkgs () {
  source_rpms=()
  for pkg; do
    pkg="$(basename "$pkg")"
    pkg="${pkg%.spec}"
    echo "Processing $pkg..."
    spectool -g -R SPECS/$pkg.spec
    rpmbuild -bs SPECS/$pkg.spec
    source_rpm="SRPMS/$(ls -1ct SRPMS | head -n1)"
    echo "Successfully generated $source_rpm!"
    source_rpms+=("$source_rpm")
  done
  echo "Compiling ${source_rpms[@]}..."
  #debug_opts="-nN --no-cleanup-after"
  debug_opts=""
  mock -r "$builder" --resultdir=$tmp_dir $debug_opts "${source_rpms[@]}"
}

if [ $# -gt 0 ]; then
  build_pkgs "$@"
else
  build_pkgs SPECS/*.spec
fi

rm -f $tmp_dir/*.src.rpm $tmp_dir/*.log
mv $tmp_dir/*.rpm RPMS/x86_64/
