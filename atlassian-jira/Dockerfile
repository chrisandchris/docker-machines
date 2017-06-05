FROM ahaasler/jira-base:alpine-8u102b14-server-jre
MAINTAINER Adrian Haasler García <dev@adrianhaasler.com>

# Configuration
ENV JIRA_VERSION 7.3.6
ENV JIRA_INSTALL /opt/jira

# Download and install jira in /opt with proper permissions and clean unnecessary files
RUN \
    curl -Lks https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-core-$JIRA_VERSION.tar.gz \
        -o /tmp/jira.tar.gz \
    && mkdir -p /opt/jira \
    && tar -zxf /tmp/jira.tar.gz --strip=1 -C /opt/jira \
    && chown -R root:root /opt/jira \
    && chown -R 547:root /opt/jira/logs /opt/jira/temp /opt/jira/work \
    && rm /tmp/jira.tar.gz

RUN \
    rm -rf /data/jira \
    && mkdir -p /data/jira \
    && chown jira:jira /data/jira

# Remove some env variables from setup, so we can set them inplace
RUN \
    chmod 0777 ${JIRA_INSTALL}/bin/setenv.sh \
    && sed -i 's/JVM_MINIMUM_MEMORY=.*//g' ${JIRA_INSTALL}/bin/setenv.sh \
    && sed -i 's/JVM_MAXIMUM_MEMORY=.*//g' ${JIRA_INSTALL}/bin/setenv.sh

COPY launch.sh /launch

RUN chmod +x /launch

EXPOSE 8080

WORKDIR /opt/jira

ENTRYPOINT ["/launch"]
