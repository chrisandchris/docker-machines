FROM openjdk:8

MAINTAINER chrisandchris

WORKDIR /var/atlassian/jira

ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ENV JIRA_VERSION  7.3.6

RUN \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends xmlstarlet \
    && apt-get install -y --no-install-recommends -t jessie-backports libtcnative-1 \
    && apt-get clean \
    && mkdir -p "${JIRA_HOME}" \
    && mkdir -p "${JIRA_HOME}/caches/indexes" \
    && mkdir -p "${JIRA_INSTALL}/conf/Catalina" \
    && curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-core-${JIRA_VERSION}.tar.gz" \
        | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" \
        | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
    && sed --in-place "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
    && touch -d "@0" "${JIRA_INSTALL}/conf/server.xml"

# Remove some env variables from setup, so we can set them inplace
RUN \
    chmod 0777 ${JIRA_INSTALL}/bin/setenv.sh \
    && sed -i 's/JVM_MINIMUM_MEMORY=.*//g' ${JIRA_INSTALL}/bin/setenv.sh \
    && sed -i 's/JVM_MAXIMUM_MEMORY=.*//g' ${JIRA_INSTALL}/bin/setenv.sh

COPY "docker-entrypoint.sh" "/"

RUN \
    chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]
