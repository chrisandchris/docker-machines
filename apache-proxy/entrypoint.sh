#!/bin/bash

service apache2 stop
certbot-auto register --agree-tos -m $NOTIFY_MAIL --non-interactive
certbot-all
service apache2 restart
cron
tail -F /var/log/apache2/*
