Lab Tools
===================

Maintain host to cluster mappings, as they change automatically rebuild the hosts
as needed.  This is ideally suited for a rapidly changing R&D/testing environment
where you'd want to have various OpenStack cluster configurations rebuilt frequently.

This will also produce an iCal file you can host somewhere so the schedule and status
can be tracked.

   * **lab-schedule-driver.py**
          - parses lab-schedule.yaml
	  - calls lab-schedule.sh to trigger automatic rebuilding when checked by cron
   * **lab-schedule.yaml**
          - contains node-to-cluster assignment, should be managed by git
   * **lab-schedule-ical-generate.sh**
          - generates the iCal file to reflect current status of nodes, tests, etc.
   * **lab-schedule-ical-driver.py**
          - used by the lab-schedule-ical-generate.sh to generate the
           ical entry for a single day.  The way to call the wrapper is:
```
    lab-schedule-ical-generate.sh lab-schedule-ical-driver.py \
    path/to/lab-schedule.yaml mm/dd/yyyy [ mm/dd/yyyy ]
```

    e.g. if I want to generate an ical file that will show the schedule for
    the months of april and may, I might run:


```
    ./lab-schedule-ical-generate.sh ./lab-schedule-ical-driver.py \
    ./../data/scale/lab-schedule.yaml \
    `for i in $(seq -w 1 30) ; do echo -n "04/$i/2014 " ; done` \
    `for i in $(seq -w 1 31) ; do echo -n "05/$i/2014 " ; done` \
      > newcal
```

    Then, copy the file newcal to your calendar host as:
    /srv/cal/calendars/schedule.ics
