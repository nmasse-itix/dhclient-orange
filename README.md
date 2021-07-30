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

## Future

In the future, starting with Kernel 5.7, the "egress" netfilter hook might be sufficient and this patch could disappear.

> Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> handle\_ing() under unique static key") introduced the ability to
> classify packets on ingress.
>
> Allow the same on egress. 
>
> This hook is also useful for NAT46/NAT64, tunneling and filtering of
> locally generated af\_packet traffic such as dhclient.

Source: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8537f78647c072bdb1a5dbe32e1c7e5b13ff1258

