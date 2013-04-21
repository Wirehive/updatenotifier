#!/bin/bash

####CUSTOMISE HERE####

FROM="support@company.com"
DESTINATION="support@company.com"

####END CUSTOMISATION####

UPDATES=`yum check-update -q | awk {'print $1 " - " $2'} | sort`

if [[ -z $UPDATES ]]; then
        echo "No updates required" && exit 1
fi

HOSTNAME=`hostname -f`
IP=`ip addr list eth0 |grep inet |cut -d' ' -f6|cut -d/ -f1`
LSB=`lsb_release -ds`
KERNEL=`uname -srm`

if type "php" &> /dev/null; then
        PHP=`php -v | head -1`
fi

if type "httpd" &> /dev/null; then
        APACHE=`httpd -v 2> /dev/null | head -1`
fi

if type "mysqld" &> /dev/null; then
        MYSQLD=`mysqld -V`
fi

SUBJECT="$HOSTNAME has updates pending"

mail -r "$FROM" -s "$SUBJECT" $DESTINATION << EOF
System $HOSTNAME has updates waiting to be installed, details below.

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
