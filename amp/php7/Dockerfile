FROM ubuntu:trusty

MAINTAINER Christian Klauenbosch <info@globalelements.ch>

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV COMPOSER_HOME=/composer
ENV DEBIAN_FRONTEND=noninteractive

# BASICS & LOCALE
RUN \
    apt-get update && apt-get upgrade -y \
    && apt-get install -y wget curl python-software-properties software-properties-common \
        zip unzip mysql-client \
    && apt-get install -y locales && locale-gen ${LANG} \
    && echo "alias suw='sudo -u www-data'" > /root/.bash_aliases

# APACHE
RUN \
    apt-get install -y \
        apache2 \
    && sed -i 's/DocumentRoot \/var\/www\/html.*/DocumentRoot \/var\/www\/web\//' /etc/apache2/sites-enabled/000-default.conf \
    && sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-enabled/000-default.conf \
    && a2enmod rewrite

# AWS CLI
RUN \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm -rf awscli-* \
    && aws --version

# PHP 7.0
RUN \
    add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated \
        php7.0-fpm php7.0-dev php7.0-curl php7.0-opcache php7.0-json php7.0-mcrypt php7.0-pgsql php7.0-gd \
        php7.0-sqlite php7.0-mysql php7.0-mbstring php7.0-bcmath php7.0-zip \
        php7.0-xml php7.0-memcached php-xdebug libapache2-mod-php7.0 \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.0/cli/php.ini \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.0/apache2/php.ini \
    && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 64M/" /etc/php/7.0/apache2/php.ini \
    && mkdir -p /etc/php/7.0/cli/conf.d \
    && mkdir -p /etc/php/7.0/apache2/conf.d \
    && echo "xdebug.remote_enable=1\n\
xdebug.profiler_enable=0\n\
xdebug.profiler_output_dir=/vagrant/cachegrind\n\
xdebug.profiler_output_name=cachegrind.cli.%p.%t.out\n\
xdebug.remote_connect_back=1\n\
xdebug.remote_port=9000\n\
xdebug.remote_log=/tmp/xdebug.log\n\
xdebug.max_nesting_level=512" >> /etc/php/7.0/cli/conf.d/20-xdebug.ini \
    && echo "xdebug.remote_enable=1\n\
xdebug.profiler_enable=0\n\
xdebug.profiler_output_dir=/vagrant/cachegrind\n\
xdebug.profiler_output_name=cachegrind.apache.%p.%t.out\n\
xdebug.remote_connect_back=1\n\
xdebug.remote_port=9000\n\
xdebug.remote_log=/tmp/xdebug.log\n\
xdebug.max_nesting_level=512" >> /etc/php/7.0/apache2/conf.d/20-xdebug.ini

RUN \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && wget https://phar.phpunit.de/phpunit-5.7.phar -O /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

WORKDIR /var/www

CMD service apache2 start && tail -f /var/log/apache2/error.log
