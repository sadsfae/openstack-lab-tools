#!/bin/sh

# this is what I ran to build the current state of the six clusters

# this is the six simple clusters
# host03-rack02.example.com has address 10.1.16.32
# host06-rack02.example.com has address 10.1.16.35
# host09-rack02.example.com has address 10.1.16.38
# host12-rack02.example.com has address 10.1.16.41
# host15-rack02.example.com has address 10.1.16.44
# host18-rack02.example.com has address 10.1.16.47

controller1=10.1.16.32
controller2=10.1.16.35
controller3=10.1.16.38
controller4=10.1.16.41
controller5=10.1.16.44
controller6=10.1.16.47

#for c in 3 6 9 12 15 18 ; do
#for c in 6 9 12 15 18 ; do
for c in 6 ; do
if [ $c -lt 10 ]; then
  pad="0"
  if [ `expr $c + 1` -lt 10 ]; then
    pad2="0"
  else
    pad2=""
  fi
  if [ `expr $c + 2` -lt 10 ]; then
    pad3="0"
  else
    pad3=""
  fi
else 
  pad=""
  pad2=""
  pad3=""
fi

./cold-kick.sh host$pad$c-rack02.example.com ipmi-$pad$c-rack02.example.com host$pad2`expr $c + 1`-rack02.example.com ipmi-$pad2`expr $c + 1`-rack02.example.com host$pad3`expr $c + 2`-rack02.example.com ipmi-$pad3`expr $c + 2`-rack02.example.com

done

# additionally we need to add compute nodes to each

cluster1="
host21-rack02
host22-rack02
"
cluster2="
host23-rack02
host24-rack02
host26-rack02
host28-rack02
host29-rack02
host30-rack02
host12-rack03
host13-rack03
host14-rack03
host15-rack03
host16-rack03
host09-rack02
host10-rack02
host11-rack02
host12-rack02
host13-rack02
host14-rack02
host15-rack02
host16-rack02
host17-rack02
host18-rack02
host19-rack02
host20-rack02
"
cluster3="
"
cluster4="
"
cluster5="
"
cluster6="
"

#for i in $(seq 1 6) ; do
#for i in $(seq 2 6) ; do
for i in $(seq 2 2) ; do
  clustername=cluster$i
  hosts=$(eval echo \$$clustername)
  controller_ip=$(eval echo \$controller$i)
  
  for h in $hosts; do  ./cold-move-nova-compute.sh $controller_ip $h.example.com `echo $h | sed 's/host/ipmi-/g'`.example.com ; done
done
