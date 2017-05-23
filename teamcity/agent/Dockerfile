FROM jetbrains/teamcity-agent

MAINTAINER chrisandchris <>

ENV LANG=en_US.UTF-8
ENV COMPOSER_HOME=/composer

RUN \
    apt-get update && apt-get upgrade -y \
    && apt-get install -y wget curl python-software-properties software-properties-common \
        zip unzip mysql-client

RUN \
    wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb -O /tmp/vagrant.deb \
    && dpkg -i /tmp/vagrant.deb \
    && vagrant plugin install vagrant-aws \
    && vagrant plugin install vagrant-scp \
    && wget https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box -O /tmp/dummy.img \
    && vagrant box add dummy /tmp/dummy.img

RUN \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm -rf awscli-* \
    && aws --version

RUN \
    wget https://releases.hashicorp.com/packer/0.12.2/packer_0.12.2_linux_amd64.zip -O /tmp/packer.zip \
    && unzip /tmp/packer.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/packer

RUN \
    apt-get update \
    && apt-get install -y locales && locale-gen ${LANG}

RUN \
    add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated \
        php7.0-fpm php7.0-dev php7.0-curl php7.0-opcache php7.0-json php7.0-mcrypt php7.0-pgsql php7.0-gd \
        php7.0-sqlite php7.0-mysql php7.0-mbstring php7.0-bcmath php7.0-zip \
        php7.0-xml php7.0-memcached \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

RUN \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && wget https://phar.phpunit.de/phpunit-5.7.phar -O /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit
