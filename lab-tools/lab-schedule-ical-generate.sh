#!/bin/sh

# Generate the ical file used to show the 
# lab scheduled utilization

# first arg is the driver script
# second arg is the calendar yaml
# remaining args are the dates
#
# example way to run, to generate the entire 
# month of april calendar:
#
# ./lab-schedule-ical-generate.sh lab-schedule-ical-driver.py lab-schedule.yaml `for i in $(seq -w 1 30) ; do echo 2014-04-$i ; done`
#

pythonscript=$1

if [ ! -f $pythonscript ]; then
  exit 1
fi
shift

# second arg is the calendar data
yamlfile=$1

if [ ! -f $yamlfile ]; then
  exit 1
fi
shift

cat <<EOF
BEGIN:VCALENDAR
X-WR-CALNAME:Scale Lab Allocations
X-WR-CALID:1aeca593-a063-461b-9218-f45e649faab0:314654
PRODID:Zimbra-Calendar-Provider
VERSION:2.0
METHOD:PUBLISH
BEGIN:VTIMEZONE
TZID:America/New_York
BEGIN:STANDARD
DTSTART:16010101T020000
TZOFFSETTO:-0500
TZOFFSETFROM:-0400
RRULE:FREQ=YEARLY;WKST=MO;INTERVAL=1;BYMONTH=11;BYDAY=1SU
TZNAME:EST
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16010101T020000
TZOFFSETTO:-0400
TZOFFSETFROM:-0500
RRULE:FREQ=YEARLY;WKST=MO;INTERVAL=1;BYMONTH=3;BYDAY=2SU
TZNAME:EDT
END:DAYLIGHT
END:VTIMEZONE
EOF

for date in $* ; do
  dtstart=`date -d $date +%Y%m%d`
  dtend=`date -d "$date + 1 day" +%Y%m%d`
  cat <<EOF
BEGIN:VEVENT
UID:$date@scalelab
SUMMARY:$date
EOF
  echo -n "DESCRIPTION:\\n"
  $pythonscript -f $yamlfile -d $date | sed 's,$,\\n,'
cat <<EOF
LOCATION:Scale Lab
DTSTART;VALUE=DATE:$dtstart
DTEND;VALUE=DATE:$dtend
STATUS:CONFIRMED
CLASS:PUBLIC
X-MICROSOFT-CDO-ALLDAYEVENT:TRUE
X-MICROSOFT-CDO-INTENDEDSTATUS:FREE
TRANSP:TRANSPARENT
LAST-MODIFIED:20100713T125033Z
DTSTAMP:20100713T125033Z
SEQUENCE:8
END:VEVENT
EOF
done
cat <<EOF
END:VCALENDAR
EOF
