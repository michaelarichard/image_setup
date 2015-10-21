# image_setup

1) Start with a minimal centos install.
# Enable network
# sed -i'' "s/ONBOOT=.*/ONBOOT=yes/g" /etc/sysconfig/network-scripts/ifcfg-eno16777736
# service network restart
# ip addr show

2) Run this to disable firewall, selinux, and fixup ethernet. (Remove GUID, Device ID, and use class eth0 naming)

curl -L https://github.com/michaelarichard/image_setup/raw/master/distros/centos/7/minimal_install_setup.sh | bash

3)  Run this to install vmware tools and customization spec requirements for vmware

curl -L https://raw.githubusercontent.com/michaelarichard/image_setup/master/distros/centos/7/vmware_tools.sh | bash

If using vmware fusion:
4) Export the vm from fusion using ovftool

./ovftool --acceptAllEulas /Users/mrichard/Documents/Virtual\ Machines.localized/Test1_CentOS7.vmwarevm/Test1_CentOS7.vmx /Users/mrichard/Desktop/centos7_minimal_test1.ova

5) Import to vmware using powerCLI:

# TODO: This doesn't work even with -force for some reason, manually import OVF using GUI for now
$cluster=ProdCluster
$datastorecluster=ProdCluster
$MyCluster= Get-Cluster $cluster
$MyDataStoreCluster= get-datastoreCluster -name $datastorecluster
$MyHost= Get-Cluster $MyCluster | Get-VMHost| where-object {$_.ConnectionState -eq 'Connected'} | Sort-Object CPUUsageMhz | select-object -first 1
Import-VApp -source .\centos7_minimal_final1.ova -Location $MyCluster -Datastore $MyDatastore -Name "CentOS_7_minimal_20151019" -vmhost $MyHost
