# Salt installation (server)

```bash
curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
sudo ./bootstrap-salt.sh -MN
```

Need to make sure salt-master and salt-minion both start up correctly. may need to change `interface` of salt-master config (/etc/salt/master) and `master` of salt-minion config (/etc/salt/minion) to the same IP address. then, run:

```bash
sudo salt-key -L
sudo salt-key -A
```
to accept salt minion key on the master. Alternatively, set `auto_accept: True` in the salt-master config.

If these services do not start up correctly (check with `sudo systemctl status salt-master` and `sudo systemctl status salt-minion`), can be run manually in the foreground with:

```bash
sudo salt-master -l debug
sudo salt-minion -l debug
```

in separate terminals

# Wake on Lan (WoL)

Enable WoL on client. First turn on BIOS options. Then enable in OS:

```bash
sudo apt install ethtool
sudo ethtool eno1
# Look for "Supports Wake-on: <opts>" and "Wake-on: <opts>"
```

Run following if <opts> contains d and does not contain g:
```bash
sudo ethtool -s eno1 wol g
```

May also need to add `up ethtool -s eth0 wol g` to iface block of /etc/network/interfaces.


Then on the server, turn on client remotely:

```bash
sudo apt install etherwake
sudo etherwake -i <interface> <mac-addr>
```

Should theoretically be able to do this with salt, but haven't been able to get any of these to work:

```bash
sudo salt-call network.wol <mac-addr> --local
sudo salt-call network.wol <mac-addr> 255.255.255.255 7
```

# PXE Boot

Start up a DHCP server on the main server. Install the server:

```bash
sudo apt install isc-dhcp-server
```

add desired interfaces to `/etc/default/isc-dhcp-server` and add the following to `/etc/dhcp/dhcpd.conf`:

```
allow booting;
allow bootp;
option arch code 93 = unsigned integer 16;
host ubuntu {
             hardware ethernet <mac-addr>;
             if option arch = 00:07 {
                     filename "boot/bootx64.efi";
             } else {
                     filename "boot/pxelinux.0";
             }
             next-server <server-ip>;
             fixed-address <server-ip>;
     }
```


```bash
sudo systemctl restart isc-dhcp-server.service
```

Setup a TFTP server:

```bash
sudo apt-get install xinetd tftpd tftp
```

Then paste the following into `/etc/xinetd.d/tftp`:

```
service tftp
{
protocol        = udp
port            = 69
socket_type     = dgram
wait            = yes
user            = nobody
server          = /usr/sbin/in.tftpd
server_args     = -s /tftpboot
disable         = no
}

```

Put files in tftpboot directory and set permissions:

```
sudo chmod -R 777 /path/to/tftpboot
sudo chown -R nobody /path/to/tftpboot
```

```bash
sudo service xinetd restart
```

dnsmasq is another option for TFTP and DHCP servers (guide):

Install dnsmasq

```bash
sudo apt install -y dnsmasq
```

Turn off systemd-resolved since it uses the same port (53) as dnsmasq
```bash
sudo systemctl stop systemd-resolved
sudo unlink /etc/resolv.conf
```

and put the following in /etc/resolv.conf:

```
nameserver 127.0.0.1
nameserver 1.1.1.1
nameserver 8.8.8.8
```

or edit `/etc/dnsmasq.conf` and uncomment port=5353 line and add desired interface for DHCP. then restart dnsmaq service


To assign static IP to DHCP computer, edit `/etc/netplan/...` with:

```
network:
  ethernets:
    eno1:
      addresses: [<static-ip-addr>/24]
      dhcp4: true
  version: 2
```

```bash
sudo netplan apply
```

Get pxe boot images:

```bash
sudo apt-get install ipxe
cp /usr/lib/ipxe/{undionly.kpxe,ipxe.efi} /tftpboot
```

clone from git:

```bash
sudo apt-get install liblzma-dev
git clone https://github.com/ipxe/ipxe.git
```

Set gcloud config:

```bash
gcloud config set project soe-licorice
gcloud config set compute/zone us-west1-b
```
