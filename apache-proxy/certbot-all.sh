#!/usr/bin/env bash

if [ ! -f /etc/apache2/sites-enabled/.hosts ] ; then
    echo "No hosts file found"
    exit 1
fi

cat /etc/apache2/sites-enabled/.hosts | while read line
do
    echo "### ---"
    echo "Handle $line"
    echo ""
    certbot --renew-with-new-domains --apache -n -d "$line"
done
