# Patched dhclient for the Orange Fibre ISP

## Why ?

The Orange Fibre ISP in France needs DHCP packets to be sent with 802.1Q priority set to "6".
The only way to accomplish this is by patching dhclient.

## How ?

On a CentOS Stream 8 server that is connected to the ONT, enable this repo.

```sh
sudo curl -o https://f003.backblazeb2.com/file/dhclient-orange/dhclient-orange.repo /etc/yum.repos.d/dhclient-orange.repo
```

And install the patched dhclient.

```sh
sudo dnf remove dhcp-client
sudo dnf install dhcp-client-orange-isp
```

Configure the connection with NetworkManager.

```sh
sudo nmcli con add type vlan con-name eno1.832 dev eno1 id 832 egress "0:0,1:0,2:0,3:0,4:0,5:0,6:6,7:0"
```

