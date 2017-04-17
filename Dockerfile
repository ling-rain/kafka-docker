FROM java:8-jre

MAINTAINER PalSzak

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.9.0.1
ENV ZOOKEEPER_SERVER zookeeper

RUN  wget -q -O - http://www.eu.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar -xzf - -C /opt \
       && mv /opt/kafka_$SCALA_VERSION-$KAFKA_VERSION /opt/kafka

ENV PATH /opt/kafka/bin:$PATH

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY ./image/conf /opt/kafka/config && sed -i "s/zookeeper:2181/$ZOOKEEPER_SERVER:2181/g" /opt/kafka/config/server.properties
VOLUME ["/opt/kafka/config"]

EXPOSE 9092

CMD  ["kafka-server-start.sh", "/opt/kafka/config/server.properties"]
