FROM jetbrains/teamcity-agent

MAINTAINER chrisandchris <>

ENV LANG=en_US.UTF-8
ENV COMPOSER_HOME=/composer
ENV DOCKER_COMPOSE_VERSION=1.16.1

# base software packages, update system
RUN \
    apt-get update && apt-get upgrade -y \
    && apt-get install -y wget curl python-software-properties software-properties-common \
        zip unzip mysql-client git

# install aws-cli
RUN \
    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws \
    && rm -rf awscli-* \
    && aws --version

# install docker-compose
RUN \
    curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` \
        > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose \
    && echo "127.0.0.1 localunixsocket.local" >> /etc/hosts

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
    &&php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    && wget https://phar.phpunit.de/phpunit-5.7.phar -O /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit \
    && mkdir /composer \
    && chmod 0777 /composer

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

COPY run-docker.sh /services/run-docker.sh
