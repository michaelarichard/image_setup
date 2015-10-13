#!/bin/sh
# lots of notes on why
#http://www.boche.net/blog/index.php/2015/08/09/rhel-7-open-vm-tools-and-guest-customization/
#

packages=vim screen net-tools

#http://www.itsprite.com/centos-7-change-network-interface-name-from/
# Fix ifconfig to match existing templating usage
# fixup eno16777736 -> eth0
mv /etc/sysconfig/network-scripts/ifcfg-eno16777736  /etc/sysconfig/network-scripts/ifcfg-eth0

# fixup grub to match
sed -i.bak 's/.*GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=centos/root crashkernel=auto  vconsole.keymap=us rhgb quiet net.ifnames=0 biosdevname=0"/' /etc/sysconfig/network-scripts/ifcfg-eth0
grub2-mkconfig  -o /boot/grub2/grub.cfg

# TODO: Enable network, wipe devID, change name to eth0
#
#

# Disable ipv6
echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p

# Disable selinux
sed -i.bak 's/SELINUXTYPE=.*/SELINUXTYPE=permissive/g' /etc/sysconfig/selinux
setenforce 0

# disable firewalld
systemctl mask firewalld
systemctl stop firewalld

# upgrade
yum install ${packages} -y
yum update -y 

shutdown -r now
