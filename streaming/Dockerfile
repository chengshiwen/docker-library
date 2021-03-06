FROM debian:stretch-slim

LABEL maintainer=chengshiwen<chengshiwen0103@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=C.UTF-8 \
    JAVA_HOME=/usr/java/latest \
    PATH=$PATH:/usr/java/latest/bin

RUN apt-get update \
 && apt-get install -y tzdata gettext-base cron \
 && apt-get install -y --no-install-recommends curl \
 && echo "Asia/Shanghai" > /etc/timezone \
 && rm -f /etc/localtime \
 && dpkg-reconfigure tzdata \
 && curl -o /tmp/server-jre-8u181-linux-x64.tar.gz -jkLH "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/server-jre-8u181-linux-x64.tar.gz \
 && mkdir -p /usr/java \
 && tar zxf /tmp/server-jre-8u181-linux-x64.tar.gz -C /usr/java \
 && ln -s /usr/java/jdk1.8.0_181 /usr/java/latest \
 && find /usr/java/latest/ -maxdepth 1 -mindepth 1 | grep -v jre | xargs rm -rf \
 && ln -s /usr/java/latest/jre/bin /usr/java/latest/bin \
 && apt-get purge -y --auto-remove curl \
 && rm -rf \
    /var/lib/apt/lists/* \
    /usr/java/latest/jre/plugin \
    /usr/java/latest/jre/bin/javaws \
    /usr/java/latest/jre/bin/jjs \
    /usr/java/latest/jre/bin/orbd \
    /usr/java/latest/jre/bin/pack200 \
    /usr/java/latest/jre/bin/policytool \
    /usr/java/latest/jre/bin/rmid \
    /usr/java/latest/jre/bin/rmiregistry \
    /usr/java/latest/jre/bin/servertool \
    /usr/java/latest/jre/bin/tnameserv \
    /usr/java/latest/jre/bin/unpack200 \
    /usr/java/latest/jre/lib/javaws.jar \
    /usr/java/latest/jre/lib/deploy* \
    /usr/java/latest/jre/lib/desktop \
    /usr/java/latest/jre/lib/*javafx* \
    /usr/java/latest/jre/lib/*jfx* \
    /usr/java/latest/jre/lib/amd64/libdecora_sse.so \
    /usr/java/latest/jre/lib/amd64/libprism_*.so \
    /usr/java/latest/jre/lib/amd64/libfxplugins.so \
    /usr/java/latest/jre/lib/amd64/libglass.so \
    /usr/java/latest/jre/lib/amd64/libgstreamer-lite.so \
    /usr/java/latest/jre/lib/amd64/libjavafx*.so \
    /usr/java/latest/jre/lib/amd64/libjfx*.so \
    /usr/java/latest/jre/lib/ext/jfxrt.jar \
    /usr/java/latest/jre/lib/ext/nashorn.jar \
    /usr/java/latest/jre/lib/oblique-fonts \
    /usr/java/latest/jre/lib/plugin.jar \
    /tmp/*

COPY entrypoint.sh streaming.sh /usr/local/bin/

RUN echo "*/1 * * * * root /bin/bash /usr/local/bin/streaming.sh" >> /etc/crontab \
 && echo "0 0 * * 0 root rm -f /tmp/streaming.log" >> /etc/crontab

ENTRYPOINT ["entrypoint.sh"]

CMD ["cron", "-f"]
