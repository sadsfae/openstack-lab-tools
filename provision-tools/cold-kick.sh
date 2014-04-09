#!/bin/sh

# invoke as such:
#  ./cold-kick.sh host03-rack02.example.com ipmi-03-rack02.example.com host04-rack02.example.com ipmi-04-rack02.example.com host05-rack02.example.com ipmi-05-rack02.example.com 
#
controller=$1
controller_ipmi=$2
neutron=$3
neutron_ipmi=$4
compute=$5
compute_ipmi=$6

if ! host $controller 1>/dev/null 2>&1 || ! host $neutron 1>/dev/null 2>&1 || ! host $compute 1>/dev/null 2>&1 || ! host $controller_ipmi 1>/dev/null 2>&1 || ! host $neutron_ipmi 1>/dev/null 2>&1 ||  ! host $compute_ipmi 1>/dev/null 2>&1 ; then
  echo Some parameter not found
  exit 2
fi

controller_ip=`host $controller | awk '{ print $NF }'`

#ssh $controller subscription-manager unregister
#/opt/dell/srvadmin/bin/idracadm -r $controller_ipmi -u root -p yourpassword serveraction powerdown 
hostid=`echo "select id, name from hosts where name = \"$controller\";" | mysql foreman | grep $controller | awk '{ print $1 }'`
echo "delete from parameters where reference_id = $hostid and type = 'HostParameter';" | mysql foreman
hammer host update --name $controller --hostgroup-id 3 --partition-table-id 14 --parameters=controller_priv_host=$controller_ip,controller_pub_host=$controller_ip,mysql_host=$controller_ip,qpid_host=$controller_ip --build=1
/opt/dell/srvadmin/bin/idracadm -r $controller_ipmi -u root -p yourpassword serveraction powerup

#ssh $neutron subscription-manager unregister
#/opt/dell/srvadmin/bin/idracadm -r $neutron_ipmi -u root -p yourpassword serveraction powerdown
hostid=`echo "select id, name from hosts where name = \"$neutron\";" | mysql foreman | grep $neutron | awk '{ print $1 }'`
echo "delete from parameters where reference_id = $hostid and type = 'HostParameter';" | mysql foreman
hammer host update --name $neutron --hostgroup-id 6 --partition-table-id 19 --parameters=controller_priv_host=$controller_ip,controller_pub_host=$controller_ip,mysql_host=$controller_ip,qpid_host=$controller_ip --build=1
/opt/dell/srvadmin/bin/idracadm -r $neutron_ipmi -u root -p yourpassword serveraction powerup

#ssh $compute subscription-manager unregister
#/opt/dell/srvadmin/bin/idracadm -r $compute_ipmi -u root -p yourpassword serveraction powerdown
hostid=`echo "select id, name from hosts where name = \"$compute\";" | mysql foreman | grep $compute | awk '{ print $1 }'`
echo "delete from parameters where reference_id = $hostid and type = 'HostParameter';" | mysql foreman
hammer host update --name $compute --hostgroup-id 4 --partition-table-id 17 --parameters=controller_priv_host=$controller_ip,controller_pub_host=$controller_ip,mysql_host=$controller_ip,qpid_host=$controller_ip --build=1
/opt/dell/srvadmin/bin/idracadm -r $compute_ipmi -u root -p yourpassword serveraction powerup
