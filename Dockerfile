FROM adoptopenjdk/openjdk11:alpine-slim

ARG VELOCITY_VERSION=3.1.0
ENV VELOCITY_JAR_URL=https://versions.velocitypowered.com/download/${VELOCITY_VERSION}.jar

RUN mkdir /velocity
WORKDIR /velocity
RUN wget -O velocity.jar $VELOCITY_JAR_URL

RUN mkdir plugins
RUN mkdir logs
COPY velocity.toml .
COPY run.sh .

CMD ["/velocity/run.sh"]
