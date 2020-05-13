FROM debian:buster as base

# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ARG TIME_ZONE

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install rsyslog --no-install-recommends -y && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /opt/etc && mkdir -p /opt/var/run && \
    cp -a --parents /usr/sbin/rsyslogd /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libz* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libdl* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/librt* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libuuid.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/liblzma.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libgcrypt.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libgpg-error.so.* /opt && \
    cp -a --parents /lib/x86_64-linux-gnu/libsystemd.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libestr.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/libfastjson.so.* /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/rsyslog /opt && \
    cp -a --parents /usr/lib/x86_64-linux-gnu/liblz4.so.* /opt && \
    cp /usr/share/zoneinfo/${TIME_ZONE:-ROC} /opt/etc/localtime

COPY rsyslog.conf /opt/etc/rsyslog.conf

FROM gcr.io/distroless/base-debian10

COPY --from=base /opt /

VOLUME [ "/var/log" ]

EXPOSE 514 514/udp

ENTRYPOINT [ "rsyslogd", "-n" ]
