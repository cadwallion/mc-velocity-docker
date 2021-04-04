FROM adoptopenjdk/openjdk8-openj9:alpine-slim

ARG VELOCITY_VERSION=1.1.2
ENV VELOCITY_JAR_URL=https://versions.velocitypowered.com/download/${VELOCITY_VERSION}.jar

RUN mkdir /velocity
WORKDIR /velocity
RUN wget -O velocity.jar $VELOCITY_JAR_URL

RUN mkdir plugins
RUN mkdir logs
COPY velocity.toml .

CMD ["java", "-Xms${JAVA_MEMORY}", "-Xmx${JAVA_MEMORY}", "-XX:UseG1GC", "-XX:G1HeapRegionSize=4M", "-XX:+UnlockExperimentalVMOptions", "-XX:+ParallelRefProcEnabled", "-XX:+AlwaysPreTouch", "-XX:MaxInlineLevel=15", "-jar", "velocity.jar"]
