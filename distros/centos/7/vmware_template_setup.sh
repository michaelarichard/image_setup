#!/bin/sh

packages=perl gcc make kernel-headers kernel-devel man screen vim open-vm-tools

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

yum install ${packages} -y
yum update -y 


