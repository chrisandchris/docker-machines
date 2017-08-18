FROM jetbrains/teamcity-agent

MAINTAINER chrisandchris <>

ENV LANG=en_US.UTF-8
ENV COMPOSER_HOME=/composer

# base software packages, update system
RUN \
    apt-get update && apt-get upgrade -y \
    && apt-get install -y wget curl python-software-properties software-properties-common \
        zip unzip mysql-client

# install vagrant and plugins
RUN \
    wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb -O /tmp/vagrant.deb \
    && dpkg -i /tmp/vagrant.deb \
    && vagrant plugin install vagrant-aws \
    && vagrant plugin install vagrant-scp \
    && wget https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box -O /tmp/dummy.img \
    && vagrant box add dummy /tmp/dummy.img

# install aws-cli
RUN \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm -rf awscli-* \
    && aws --version

# install packer
RUN \
    wget https://releases.hashicorp.com/packer/0.12.2/packer_0.12.2_linux_amd64.zip -O /tmp/packer.zip \
    && unzip /tmp/packer.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/packer

# install docker, docker-compose
RUN \
    apt-get install -y \
           apt-transport-https \
           ca-certificates \
           curl \
           software-properties-common \
           lxc \
   && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
   && add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) \
         stable" \
    && apt-get update \
    && apt-get install -y docker-ce \
    && curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && echo "@reboot service docker start" >> /etc/crontab

# generate localse
RUN \
    apt-get update \
    && apt-get install -y locales && locale-gen ${LANG}

# install php
RUN \
    add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated \
        php7.0-fpm php7.0-dev php7.0-curl php7.0-opcache php7.0-json php7.0-mcrypt php7.0-pgsql php7.0-gd \
        php7.0-sqlite php7.0-mysql php7.0-mbstring php7.0-bcmath php7.0-zip \
        php7.0-xml php7.0-memcached \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

# install phpunit and composer
RUN \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && wget https://phar.phpunit.de/phpunit-5.7.phar -O /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# install sphinx, latex
RUN \
    apt-get install -y \
        python-virtualenv build-essential python-dev python-pip python-setuptools \
        libxml2-dev libxslt1-dev zlib1g-dev python-sphinx \
        texlive-base texlive-latex-recommended \
        texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra \
        texlive-latex-base texlive-lang-german \
        inkscape

# install node
RUN \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g bower
