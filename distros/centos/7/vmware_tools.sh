#!/bin/sh
# lots of notes on why
#http://www.boche.net/blog/index.php/2015/08/09/rhel-7-open-vm-tools-and-guest-customization/
#
vmware_packages=open-vm-tools open-vm-tools-deploypkg perl gcc make kernel-headers kernel-devel
# vmware fix
#https://lonesysadmin.net/2015/01/06/centos-7-refusing-vmware-vsphere-guest-os-customizations/
rm -f /etc/redhat-release && touch /etc/redhat-release && echo "Red Hat Enterprise Linux Server release 7.0 (Maipo)" > /etc/redhat-release


#http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2075048
curl http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub > vmware.key
rpm --import vmware.key
# add vmware repo

cat << EOF > /etc/yum.repos.d/vmware-tools.repo 
[vmware-tools]
name = VMware Tools
baseurl = http://packages.vmware.com/packages/rhel7/x86_64/
enabled = 1
gpgcheck = 1
EOF

yum install -y ${vmware_packages}
