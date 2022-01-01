FROM ruby:3 AS builder
ARG VELOCITY_VERSION=3.1.1
COPY fetch-velocity.rb .
RUN ruby fetch-velocity.rb $VELOCITY_VERSION

FROM adoptopenjdk/openjdk11:alpine-slim AS production
RUN mkdir /velocity
WORKDIR /velocity
RUN mkdir plugins
RUN mkdir logs
COPY velocity.toml .
COPY run.sh .
COPY --from=builder velocity.jar .

CMD ["/velocity/run.sh"]
