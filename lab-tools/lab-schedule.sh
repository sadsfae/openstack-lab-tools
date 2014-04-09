#!/bin/sh
# takes two arguments. 
#
#    lab-schedule.sh hostname clustername
#
#  Assumes that the cache for current cluster
#  allocations is stored in `dirname $0`/data
#
#  e.g. if you store the scripts in :
#     /srv/schedule
#  you will have a data dir in:
#     /srv/schedule/data
#  the contents of the directory are files
#  named after the hosts in the yaml file, and the
#  content of each is the current cluster allocation.

datapath=`dirname $0`/data

clusternode=$1
clustername=$2

rebuild_host () {
  # ADD CODE TO REBUILD: $1 in $2
  # e.g. calls to hammer CLI to change host settings
  # and ipmitool calls to powercycle / kickstart hosts
  true
}

if [ -z "$clusternode" ]; then
  exit 1
fi

if [ -z "$clustername" ]; then
  exit 1
fi

if [ ! -d $datapath ]; then
  if mkdir $datapath ; then
    :
  else
    exit 1
  fi
fi

if [ ! -f $datapath/$clusternode ]; then
  echo "assuming $clustername is current for $clusternode"
  echo $clustername > $datapath/$clusternode
else
  if [ `cat $datapath/$clusternode` = $clustername ]; then
    :
  else
    echo "rebuild $clusternode for cluster $clustername"
    echo $clustername > $datapath/$clusternode
    rebuild_host $clusternode $clustername
  fi
fi

