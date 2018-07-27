# AlpineLinux with a glibc-2.27-r0 and Oracle Java 8
FROM alpine:3.7

LABEL maintainer="Anastas Dancha <anapsix@random.io>"

# Java Version and other ENV
ENV JAVA_PACKAGE=jdk \
    JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=181 \
    JAVA_VERSION_BUILD=13 \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    CLASSPATH=.:/opt/jdk/lib/dt.jar:/opt/jdk/lib/tools.jar \
    GLIBC_VERSION=2.27-r0 \
    LANG=C.UTF-8

ARG JAVA_DOWNLOAD_DIGEST=96a7b8442fe848ef90c96a2fad6ed6d1
ARG GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc

# Do all in one step
RUN set -ex && \
    apk -U upgrade && \
    apk add libstdc++ curl ca-certificates bash gettext java-cacerts eudev && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    echo "Asia/Shanghai" > /etc/TZ && \
    echo "Asia/Shanghai" > /etc/timezone && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    mkdir /opt && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_DOWNLOAD_DIGEST}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    JAVA_PACKAGE_SHA256=$(curl -sSL https://www.oracle.com/webfolder/s/digest/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}checksum.html | grep -E ">${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64\.tar\.gz" | grep -Eo '(sha256: )[^<]+' | cut -d: -f2 | xargs) && \
    echo "${JAVA_PACKAGE_SHA256}  /tmp/java.tar.gz" > /tmp/java.tar.gz.sha256 && \
    sha256sum -c /tmp/java.tar.gz.sha256 && \
    gunzip /tmp/java.tar.gz && \
    tar -C /opt -xf /tmp/java.tar && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ $JAVA_HOME/jre/lib/security/java.security && \
    apk del curl glibc-i18n && \
    rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /tmp/* /var/cache/apk/* && \
    ln -sf /etc/ssl/certs/java/cacerts $JAVA_HOME/jre/lib/security/cacerts && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# Define default command
CMD ["java", "-version"]
