#!/bin/sh

# invoke as such:
#  First arg is the controller IP.
#  
#  e.g.
#  ./cold-move-nova-compute.sh 10.1.16.32 host0x-rack0y.example.com ipmi-0x-rack0y.example.com
#
# host03-rack02.example.com has address 10.1.16.32
# host06-rack02.example.com has address 10.1.16.35
# host09-rack02.example.com has address 10.1.16.38
# host12-rack02.example.com has address 10.1.16.41
# host15-rack02.example.com has address 10.1.16.44
# host18-rack02.example.com has address 10.1.16.47
#
controller=$1
compute=$2
compute_ipmi=$3

if ! host $controller 1>/dev/null 2>&1 || ! host $compute 1>/dev/null 2>&1 || ! host $compute_ipmi 1>/dev/null 2>&1 ; then
  echo Some parameter not found
  exit 2
fi

controller_ip=$controller

#ssh $compute subscription-manager unregister
#/opt/dell/srvadmin/bin/idracadm -r $compute_ipmi -u root -p yourpassword serveraction powerdown
hostid=`echo "select id, name from hosts where name = \"$compute\";" | mysql foreman | grep $compute | awk '{ print $1 }'`
echo "delete from parameters where reference_id = $hostid and type = 'HostParameter';" | mysql foreman
hammer host update --name $compute --hostgroup-id 4 --partition-table-id 17 --parameters=controller_priv_host=$controller_ip,controller_pub_host=$controller_ip,mysql_host=$controller_ip,qpid_host=$controller_ip --build=1
/opt/dell/srvadmin/bin/idracadm -r $compute_ipmi -u root -p yourpassword serveraction powerup
