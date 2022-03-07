FROM confluentinc/cp-kafka-connect:5.3.1

EXPOSE 8083
ENV CONNECT_PLUGIN_PATH='/usr/share/java,/usr/local/share/kafka/plugins'
ENV CONNECT_CONNECTOR_CLIENT_CONFIG_OVERRIDE_POLICY='All'

COPY /src/main/docker/libs/* /usr/local/lib/
RUN mkdir -p /usr/local/share/kafka/plugins
COPY src/main/docker/bin/docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh
RUN mkdir -p /usr/share/java/kafka-connect/deb

COPY /src/main/docker/plugins/elastic-source-connect-*.jar /usr/share/java/kafka-connect/
COPY /src/main/docker/plugins/elastic-source-connect-*.jar /usr/share/java/kafka/
COPY /src/main/docker/plugins/elastic-source-connect-*.jar /usr/share/java/
COPY /src/main/docker/plugins/elastic-source-connect-*.jar /usr/local/share/kafka/plugins/


RUN chmod -R a+rwx /usr/share/java
RUN mkdir -p /connect-config
RUN chmod -R a+rwx /connect-config

ENV CLASSPATH="$CLASSPATH:/usr/share/java/kafka/*"

ENTRYPOINT ["/docker-entrypoint.sh"]




