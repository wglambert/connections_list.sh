#!/bin/bash

set -- $(cat /DB/_DB.003/var/register/system/dhcp/dhcpd.leases | grep "client-hostname" -B 9 | grep -E -o "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
# Make DHCP IP's which have a corresponding hostname into positional parameters

array=()
for (( IP_array_var="$#"; IP_array_var>0; IP_array_var-- )); do
        array+=("$1")
        shift
done
# Make positional parameters into a positional array

set -- $(cat /DB/_DB.003/var/register/system/dhcp/dhcpd.leases | grep "client-hostname" | cut -d'"' -f2)
# Make DHCP leases with hostnames into positional parameters

array2=()
for (( Hostname_array_var="$#"; Hostname_array_var>0; Hostname_array_var-- )); do
        array2+=("$1")
        shift
done
# Make new positional parameters into Hostname_array


mkdir -p /tmp/lan_dir

array[${#array[*]}]="[Static LAN IP]"
array2[${#array2[*]}]="[Hostname of static IP]"
# Add static DHCP's

set -- $(ls /tmp/lan_dir/)
lan_dir_array=() 
for (( a="$#"; a>0; a-- )); do
        lan_dir_array+=("$1")
        shift
done
# Make newly created files into a lan_dir_array


#for (( Hostname_array_var=${#array2[@]}; Hostname_array_var>=0; Hostname_array_var-- ;)) do

#	IP_array_var=${#IP_array[@]};
#	IP_array_var--;

#	echo ${array2[Hostname_array_var]}
#	echo ${array[IP_array_var]}
#done


for (( i=0;i<${#array[@]};++i )); do
	conntrack -L -s "${array[i]}" | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | grep -v 192.168.1.1 | grep -v 192.168. | sort -u -o /tmp/lan_dir/IP_translate.tmp
	set -- $(cat /tmp/lan_dir/IP_translate.tmp)
#"${array2[i]}"
	for x in "$@"; do
			host "$1" | grep -v NXDOMAIN | grep -v 1e100.net | grep -v amazonaws.com | grep -v cloudfront.net >> /tmp/lan_dir/"${array2[i]}"

			shift
			done

########	host ${array[var]} | grep -v NXDOMAIN
#/tmp/lan_dir/"${array2[i]}"
done

rm /tmp/lan_dir/IP_translate.tmp

set -- $(ls /tmp/lan_dir/)
array3=()
for (( a="$#"; a>0; a-- )); do
        array3+=("$1")
        shift
done
# Make newly created files into array3


for (( b=${#array3[@]}; b>=0; b-- )) ; do
	echo "${array3[b]}"
	cat /tmp/lan_dir/"${array3[b]}"
	echo -e "=============== \n"
done

rm -f /tmp/lan_dir/*
