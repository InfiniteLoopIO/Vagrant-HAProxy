#!/bin/bash

echo "Enter IP to use for haproxy"
read haproxy
echo "Enter IP to use for nginx1"
read nginx1
echo "Enter IP to use for nginx2"
read nginx2
echo "Enter IP to use for DNS"
read dns
echo "Enter IP to use for default gateway"
read gw

echo
nmcli d
echo
echo "Enter device to use as bridge"
read bridgedev

echo
fileprefix=ifcfg-eth1
namearr=(haproxy nginx1 nginx2)
for  x in ${namearr[@]} ; do
	echo "Creating interface file for $x"
	filename=${fileprefix}_$x
	cp ifcfg.template $filename
	sed -i "s/<GW>/$gw/1" $filename
	sed -i "s/<DNS>/$dns/1" $filename
done

echo
echo Adding static IP to interface files
sed -i "s/<IP>/$haproxy/1" ${fileprefix}_haproxy
sed -i "s/<IP>/$nginx1/1" ${fileprefix}_nginx1
sed -i "s/<IP>/$nginx2/1" ${fileprefix}_nginx2

echo
echo Creating HAProxy config file
cp haproxy.template haproxy.cfg
sed -i "s/<NGINX1>/$nginx1/1" haproxy.cfg
sed -i "s/<NGINX2>/$nginx2/1" haproxy.cfg

echo
echo Creating Vagrant file
cp Vagrantfile.template Vagrantfile
sed -i "s/<BRIDGEDEV>/$bridgedev/1" Vagrantfile
