#!/usr/bin/env bash

if [ ! -f /etc/apache2/sites-enabled/.hosts ] ; then
    echo "No hosts file found, abort."
    exit 1
fi

cat /etc/apache2/sites-enabled/.hosts | while read line
do
    echo "### ---"
    echo "Handle $line"
    echo ""
    certbot-auto --renew-with-new-domains --apache -n -d "$line"
    echo ""
    echo "### ---"
done

service apache2 force-reload
