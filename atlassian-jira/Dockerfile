FROM openjdk:8

MAINTAINER chrisandchris

WORKDIR /var/atlassian/jira

ENV JIRA_HOME       /var/atlassian/jira
ENV JIRA_INSTALL    /opt/atlassian/jira
ENV JIRA_VERSION    7.3.6
ENV SERVICE_VERSION 7.3.6
ENV ATLASSIAN_URL   https://www.atlassian.com/software/jira/downloads/binary

RUN \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends xmlstarlet \
    && apt-get install -y --no-install-recommends -t jessie-backports libtcnative-1 \

COPY response_jira.varfile /tmp
COPY response_sd.varfile /tmp

# Install JIRA unattended
RUN \
    && curl -o /tmp/jira-installer.bin -fsSL ${ATLASSIAN_URL}/atlassian-jira-software-${JIRA_VERSION}-x64.bin \
    && curl -o /tmp/sd-installer.bin -fsSL ${ATLASSIAN_URL}/atlassian-jira-service-desk-${JIRA_VERSION}-x64.bin \
    && chmod u+x /tmp/jira-installer.bin \
    && chmod u+x /tmp/sd-installer.bin \
    && sh -c "/tmp/jira-installer.bin -q -varfile /tmp/response_jira.varfile" \
    && sh -c "/tmp/sd-installer.bin -q -varfile /tmp/response_sd.varfile" \
    && rm /tmp/*.bin \
    && chown -R jira:jira /var/atlassian/application-data \
    && chown -R jira:jira /opt/atlassian/jira \
    && rm -rf /opt/atlassian/jira/work \
    && echo "jira.websudo.is.disabled = true" > /var/atlassian/application-data/jira-config.properties

# Remove some env variables from setup, so we can set them inplace
RUN \
    chmod 0777 ${JIRA_INSTALL}/bin/setenv.sh \
    && sed -i 's/JVM_MINIMUM_MEMORY=.*//g' ${JIRA_INSTALL}/bin/setenv.sh \
    && sed -i 's/JVM_MAXIMUM_MEMORY=.*//g' ${JIRA_INSTALL}/bin/setenv.sh

COPY "docker-entrypoint.sh" "/"

USER jira

ENTRYPOINT ["/opt/atlassian/jira/bin/start-jira.sh", "-fg"]
