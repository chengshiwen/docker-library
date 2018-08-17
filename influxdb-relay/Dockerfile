FROM alpine:3.7

RUN apk add --no-cache ca-certificates

EXPOSE 9096

COPY relay.toml /etc/

COPY influxdb-relay entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

CMD ["influxdb-relay", "-config", "/etc/relay.toml"]
