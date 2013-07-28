#!/bin/bash

####CUSTOMISE HERE####

FROM="support@company.com"
DESTINATION="support@company.com"

####END CUSTOMISATION####

UPDATES=`apt-get update -qq && apt-get -s dist-upgrade | awk '/^Inst/ { print $2 " - " $3 }' | sort`

if [[ -z $UPDATES ]]; then
        echo "No updates required" && exit 1
fi

HOSTNAME=`hostname -f`
IP=`ip addr list eth0 |grep inet |cut -d' ' -f6|cut -d/ -f1`
REBOOT=`/usr/lib/update-notifier/update-motd-reboot-required`
LSB=`lsb_release -ds`
KERNEL=`uname -srm`

if type "php" &> /dev/null; then
        PHP=`php -v | head -1`
fi

if type "apache2" &> /dev/null; then
        APACHE=`apache2 -v | head -1`
fi

if type "mysqld" &> /dev/null; then
        MYSQLD=`mysqld -V`
fi

SUBJECT="**UPDATE** $HOSTNAME has updates pending"

mail -a "From:$FROM" -s "$SUBJECT" $DESTINATION << EOF
System $HOSTNAME has updates waiting to be installed, details below.

$REBOOT

IP Addresses:
$IP

Current versions:
$LSB
$KERNEL
$APACHE
$PHP
$MYSQLD

Updates available:
$UPDATES
EOF
