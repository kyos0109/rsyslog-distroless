FROM debian:9.5 as base

# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
ARG TIME_ZONE

RUN apt-get update && \
	apt-get install rsyslog -y && \
	apt-get clean autoclean && \
	apt-get autoremove --yes && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir -p /opt/etc && mkdir -p /opt/var/run && \
	cp -a --parents /usr/sbin/rsyslogd /opt && \
	cp -a --parents /lib/x86_64-linux-gnu/libz.so.* /opt && \
	cp -a --parents /lib/x86_64-linux-gnu/libd* /opt && \
	cp -a --parents /lib/x86_64-linux-gnu/libuuid.so.* /opt && \
	cp -a --parents /lib/x86_64-linux-gnu/libgcc_s.so.* /opt && \
	cp -a --parents /usr/lib/x86_64-linux-gnu/libestr.so.* /opt && \
	cp -a --parents /usr/lib/x86_64-linux-gnu/libfastjson.so.* /opt && \
	cp -a --parents /usr/lib/x86_64-linux-gnu/liblogging-stdlog.so.* /opt && \
	cp -a --parents /usr/lib/x86_64-linux-gnu/rsyslog /opt && \
	cp /usr/share/zoneinfo/${TIME_ZONE:-ROC} /opt/etc/localtime

COPY rsyslog.conf /opt/etc/rsyslog.conf

FROM gcr.io/distroless/base

COPY --from=base /opt /

VOLUME [ "/var/log" ]

EXPOSE 514 514/udp

ENTRYPOINT [ "rsyslogd", "-n" ]
