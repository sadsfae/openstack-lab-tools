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
          - ????
