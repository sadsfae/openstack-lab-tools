#!/usr/bin/env python
#
# Call this as:
#
#    lab-schedule-driver.py -f path/to/schedule.yaml
#
# Based on the current date, this script checks to see
# if any changes are presented in the cluster allocations 
# and if so, calls the external script:
#
#   /usr/local/bin/lab-schedule.sh <hostname> <clustername>
#
# The lab-schedule.sh script maintains the allocations of
# hosts, and if it finds the host has changed its cluster
# assignment, action is taken to rebuild the host (or cluster)
# as needed.

import os
import getpass
import sys
import datetime
import time
import smtplib
import yaml
from optparse import OptionParser

if __name__ =='__main__':
    parser = OptionParser()
    parser.add_option('-f', '--file', dest='file',
                      help='YAML file with cluster data',
                      default=None, type='string')
    (opts, args) = parser.parse_args()

    if opts.file is not None:
        try:
            now = datetime.date.today()
            # print str(now)
            schedule = yaml.load(open(opts.file,'r'))

            for member in schedule.keys():
		if member == "clusters":
                    # print "Found clusters ..."
                    for clustername in schedule[member]:
                        # print "    " + clustername
                        True

                if member == "hostnames":
                    # print "Found hostnames ..."
                    for hostname in schedule[member]:
                        # print "    " + hostname
                        if schedule.get(hostname,False):
                            if schedule[hostname].get("cluster",False):
                                for scheddate in schedule[hostname]["cluster"].keys():
                                    # print "        " + str(scheddate)
                                    if scheddate == now:
                                        # print "Ensure " + hostname + " is set for " + schedule[hostname]["cluster"][now]
                                        os.system(os.path.dirname(sys.argv[0]) + "/lab-schedule.sh " + hostname + " " + schedule[hostname]["cluster"][now])

        except Exception, ex:
            print "There was a problem with your file %s" % ex
            SystemExit(4)

