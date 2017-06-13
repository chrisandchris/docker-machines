FROM ahaasler/jira-base:alpine-8u102b14-server-jre
MAINTAINER Chrisandchris <null@example.org>

# Configuration
ENV CONF_VERSION              6.2.0
ENV DOWNLOAD_URL              http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz
ENV MYSQL_VERSION             5.1.38
ENV MYSQL_DRIVER_DOWNLOAD_URL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz

RUN \
    curl -Lks $DOWNLOAD_URL \
        -o /tmp/confluence.tar.gz \
    && mkdir -p /opt/confluence \
    && tar -zxf /tmp/confluence.tar.gz --strip=1 -C /opt/confluence \
    && chown -R root:root /opt/confluence \
    && chown -R 547:root /opt/confluence/logs /opt/confluence/temp /opt/confluence/work \
    && rm /tmp/confluence.tar.gz \
    && echo -e "\nconfluence.home=/data/confluence" \
        >> "/opt/confluence/confluence/WEB-INF/classes/confluence-init.properties"

RUN \
    curl -Ls "${MYSQL_DRIVER_DOWNLOAD_URL}" \
        | tar -xz --directory "/opt/confluence/confluence/lib" \
            --strip-components=1 --no-same-owner \
            "mysql-connector-java-${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}-bin.jar"

RUN \
    rm -rf /data/confluence \
    && mkdir -p /data/confluence \
    && chown root:root /data/confluence \
    && chmod 0777 /data \
    && chmod 0777 /data/confluence

# Remove some env variables from setup, so we can set them inplace
RUN \
    chmod 0777 /opt/confluence/bin/setenv.sh \
    && sed -i 's/JVM_MINIMUM_MEMORY=.*//g' /opt/confluence/bin/setenv.sh \
    && sed -i 's/JVM_MAXIMUM_MEMORY=.*//g' /opt/confluence/bin/setenv.sh

VOLUME ["/opt/confluence", "/data/confluence"]

EXPOSE 8090
EXPOSE 8091

WORKDIR /opt/confluence

CMD ["./bin/catalina.sh", "run"]
