#!/bin/sh

set -Eeuo pipefail

mkdir -p REPO/x86_64 REPO/sources

rsync -a --ignore-existing RPMS/x86_64/ REPO/x86_64
rsync -a --ignore-existing SRPMS/ REPO/sources

createrepo REPO/x86_64
createrepo REPO/sources

cat > REPO/dhclient-orange.repo <<"EOF"
[dhclient-orange]
name=dhclient Orange - CentOS Stream 8 - $basearch
baseurl=https://f003.backblazeb2.com/file/dhclient-orange/$basearch/
enabled=1
countme=1
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=0
skip_if_unavailable=False

[dhclient-orange-source]
name=dhclient Orange - CentOS Stream 8 - Source
baseurl=https://f003.backblazeb2.com/file/dhclient-orange/sources/
enabled=0
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=0
skip_if_unavailable=False
EOF

rclone sync -P REPO/ backblaze:dhclient-orange

