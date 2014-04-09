#!/usr/bin/env python
#
# Call this as:
#
#    lab-schedule-ical-driver.py -f path/to/schedule.yaml [ -d date ]
#
# spits out the schedule for current date or the date given with -d
#

import os
import getpass
import sys
import datetime
import time
import smtplib
import yaml
from optparse import OptionParser
from dateutil import parser

if __name__ =='__main__':
    optparser = OptionParser()
    optparser.add_option('-f', '--file', dest='file',
                      help='YAML file with cluster data',
                      default=None, type='string')
    optparser.add_option('-d', '--date', dest='targetdate',
                      help='target date to operate on',
                      default=None, type='string')
    (opts, args) = optparser.parse_args()
    results = {}
    clustersizes = {}

    if opts.file is not None:
        try:
            now = datetime.date.today()
            if opts.targetdate is not None:
                now = parser.parse(opts.targetdate).date()
            schedule = yaml.load(open(opts.file,'r'))

            # not doing anything with the clusters section yet
            for member in schedule.keys():
		if member == "clusters":
                    for clustername in schedule[member]:
                        True

                if member == "hostnames":
                    for hostname in schedule[member]:
                        latestdate = parser.parse("1970-01-01").date()
                        if schedule.get(hostname,False):
                            if schedule[hostname].get("cluster",False):
                                for scheddate in schedule[hostname]["cluster"].keys():
                                    if scheddate <= now:
                                        if scheddate > latestdate:
                                            latestdate = scheddate

                                if schedule[hostname]["cluster"].get(latestdate,False):
                                    results[hostname] = schedule[hostname]["cluster"][latestdate]
                                    clustersizes[schedule[hostname]["cluster"][latestdate]] = 0

        except Exception, ex:
            print "There was a problem with your file %s" % ex
            SystemExit(4)

    for hostname in results.keys():
        clustersizes[results[hostname]] += 1

    for cluster in sorted(clustersizes.keys()):
        print " " + cluster + " " + str(clustersizes[cluster]) + " (" + schedule["clusters"][cluster] + ")"

