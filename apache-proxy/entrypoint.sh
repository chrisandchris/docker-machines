#!/bin/bash

service apache2 stop
letsencrypt register --agree-tos -m $NOTIFY_MAIL --non-interactive
certbot --renew-with-new-domains
service apache2 restart
cron
tail -F /var/log/apache2/*
