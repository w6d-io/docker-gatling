FROM openjdk:19-jdk-alpine3.15

ARG VCS_REF
ARG BUILD_DATE
ARG VERSION
ARG USER_EMAIL="david.alexandre@w6d.io"
ARG USER_NAME="David ALEXANDRE"
LABEL maintainer="${USER_NAME} <${USER_EMAIL}>" \
        io.w6d.vcs-ref=$VCS_REF \
        io.w6d.vcs-url="https://github.com/w6d-io/docker-gatling" \
        io.w6d.build-date=$BUILD_DATE \
        io.w6d.version=$VERSION

ARG GATLING_VERSION="3.7.4"
ENV PATH=/usr/local/sbt/bin:/opt/gatling/bin:$PATH \
    GATLING_HOME=/opt/gatling

RUN export PATH="/usr/local/sbt/bin:$PATH" \
    && apk update && apk --no-cache add ca-certificates \
    wget                       \
    tar                        \
    bash                       \
    gnupg                      \
    git                        \
    curl                       \
    jq                         \
    && rm -rf /var/cache/apk/* \
    && mkdir -p "/usr/local/sbt" \
    && wget -qO - --no-check-certificate "https://github.com/sbt/sbt/releases/download/v1.6.1/sbt-1.6.1.tgz" | tar xz -C /usr/local/sbt --strip-components=1 \
    && wget -O /tmp/gatling.zip https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/${GATLING_VERSION}/gatling-charts-highcharts-bundle-${GATLING_VERSION}-bundle.zip \
    && unzip -x -d /tmp /tmp/gatling.zip \
    && mv /tmp/gatling-charts-highcharts-bundle-${GATLING_VERSION} ${GATLING_HOME} \
    && rm -rf /tmp/gatling.zip \
    && sed -i 's/-XX:-UseBiasedLocking//' /opt/gatling/bin/gatling.sh

WORKDIR  /opt/gatling

VOLUME ["/opt/gatling/conf", "/opt/gatling/results", "/opt/gatling/user-files"]

ENTRYPOINT ["gatling.sh"]

