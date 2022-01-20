#!/bin/bash
set -euo pipefail
set -x
hostname=`hostname -f | xargs`
sudo yum install krb5-server krb5-libs -y
cd /etc
sudo sed -i "s|# default_realm = EXAMPLE.COM| default_realm = EXAMPLE.COM|g" krb5.conf
sudo sed -i "s|# EXAMPLE.COM| EXAMPLE.COM|g" krb5.conf
sudo sed -i "s|#  kdc = kerberos.example.com|  kdc = $hostname:88|g" krb5.conf
sudo sed -i "s|#  admin_server = kerberos.example.com|  admin_server = $hostname:749|g" krb5.conf
sudo sed -i "s|# }| default_domain = ec2.internal \n}|g" krb5.conf
sudo sed -i "s|# .example.com = EXAMPLE.COM| .ec2.internal = EXAMPLE.COM|g" krb5.conf
sudo sed -i "s|# example.com = EXAMPLE.COM| ec2.internal = EXAMPLE.COM|g" krb5.conf
wait
cd /var/kerberos/krb5kdc
sudo sed -i "s|#master_key_type = aes256-cts|master_key_type = aes256-cts|g" kdc.conf

sudo kdb5_util create -r EXAMPLE.COM -s <<EOF





chnageit
chnageit
EOF
wait
sudo kadmin.local addprinc root/admin <<EOF
chnageit
chnageit
EOF
wait
sudo service krb5kdc.service start
sudo service kadmin.service start
sudo systemctl enable krb5kdc.service
sudo systemctl enable kadmin.service
sleep 2
sudo kadmin.local addprinc -randkey host/$hostname
sudo kadmin.local ktadd host/$hostname
sudo kadmin.local cpw kadmin/admin <<EOF
chnageit
chnageit
EOF
