#!/bin/sh
# lots of notes on why
#http://www.boche.net/blog/index.php/2015/08/09/rhel-7-open-vm-tools-and-guest-customization/
#

packages="vim screen net-tools"

#http://www.itsprite.com/centos-7-change-network-interface-name-from/
# Fix ifconfig to match existing templating usage
# fixup eno16777736 -> eth0
eth_name=eth0
eth_file=/etc/sysconfig/network-scripts/ifcfg-${eth_name}
if [ -f /etc/sysconfig/network-scripts/ifcfg-eno16777736 ]; then 
  mv /etc/sysconfig/network-scripts/ifcfg-eno16777736  ${eth_file}
fi

# fixup grub to match
sed -i'' 's/.*GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="rd.lvm.lv=centos\/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=centos\/root crashkernel=auto  vconsole.keymap=us rhgb quiet net.ifnames=0 biosdevname=0"/' /etc/sysconfig/grub
grub2-mkconfig  -o /boot/grub2/grub.cfg

# Enable network, wipe device and UUID, change name to eth0
sed -i'' "s/NAME=.*/NAME=${eth_name}/" ${eth_file}
sed -i'' 's/ONBOOT=.*/ONBOOT=yes/' ${eth_file}
sed -i'' '/UUID=.*/d' ${eth_file}
sed -i'' '/DEVICE=.*/d' ${eth_file}


# Disable ipv6
echo 'net.ipv6.conf.all.disable_ipv6 = 1' > /etc/sysctl.d/disableipv6.conf
sysctl -p

# Disable selinux
sed -i'' 's/SELINUX=.*/SELINUX=permissive/g' /etc/sysconfig/selinux
setenforce 0

# disable firewalld
systemctl mask firewalld
systemctl stop firewalld

# ssh_host_keys
rm -rf /etc/ssh/ssh_host_*
/bin/systemctl restart  sshd.service

# upgrade
yum install ${packages} -y
yum update -y 

# Logs to clear
for i in `find /var/log/. -type f`; do >${i} ; done

# delete this script so it doesn't get run again
me=`basename "$0"`
rm ${me}

# clear history
> /root/.bash_history

# shutdown and restart
shutdown -r now
