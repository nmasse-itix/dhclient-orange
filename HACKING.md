# Hacking Guide

## Setup the development environment

Pre-requisites:

- Fedora 34 or higher
- mock
- rpmdevtools
- rpm-build
- git (with LFS enabled)
- createrepo
- rsync
- rclone

```sh
cd ~
git clone https://github.com/nmasse-itix/dhclient-orange.git rpmbuild
```

See https://rpm-packaging-guide.github.io/

## Building

```sh
cd ~/rpmbuild
rpm -Uvh SRPMS/dhcp-*.src.rpm
git checkout -- SPECS/dhcp.spec
./build.sh
./release.sh
```

## Backport new version of dhclient

On a CentOS Steam machine:

```sh
cd /tmp
dnf download dhcp --source
```

And then, on your development machine:

```sh
scp centos-stream-machine:/tmp/dhcp-*.src.rpm SOURCES
rpm -Uvh SOURCES/dhcp-x.y.z-patch.src.rpm
```

Do a git diff to see potential changes against current version.
Do not forget to:

- change the version/release from x.y.z-t to x.y.z-t.itix1
- change the package name from client to client-orange-isp
- re-add the patch "dhcp-orange-fibre.patch"

```sh
./build.sh
./release.sh
```
