FROM ubuntu:zesty

ENV OS_LOCALE="en_US.UTF-8"

RUN \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y locales && locale-gen ${OS_LOCALE}

ENV LANG=${OS_LOCALE} \
    LANGUAGE=en_US:en \
    LC_ALL=${OS_LOCALE} \
    APACHE_CONF_DIR=/etc/apache2 \
    NOTIFY_MAIL=null@example.org

RUN    \
    apt-get install -y software-properties-common python-software-properties vim incron \
    && add-apt-repository -y ppa:ondrej/apache2 \
    && apt-get update \
        && apt-get install -y curl apache2 python-mod-pywebsocket \
        # Apache settings
        && cp /dev/null ${APACHE_CONF_DIR}/conf-available/other-vhosts-access-log.conf \
        && rm ${APACHE_CONF_DIR}/sites-enabled/000-default.conf ${APACHE_CONF_DIR}/sites-available/000-default.conf \
    && a2enmod rewrite proxy proxy_http ssl proxy_ajp proxy_wstunnel headers \
    # Cleaning
    && apt-get purge -y --auto-remove $buildDeps locales \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    # Forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log \
    && ln -sf /dev/stderr /var/log/apache2/other_vhosts_access.log

RUN \
    add-apt-repository ppa:certbot/certbot \
    && apt-get update \
    && apt-get install -y python-certbot-apache \
    && echo "0 * * * * certbot --renew-with-new-domains" >> /tmp/crontab \
    && echo "" >> /tmp/crontab \
    && crontab /tmp/crontab

COPY entrypoint.sh /sbin/entrypoint.sh
RUN \
    chmod 755 /sbin/entrypoint.sh
COPY ./configs/apache2.conf ${APACHE_CONF_DIR}/apache2.conf

WORKDIR /var/www

EXPOSE 80 443

CMD ["/sbin/entrypoint.sh"]
