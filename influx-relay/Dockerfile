FROM alpine:3.7

RUN apk add --no-cache ca-certificates

EXPOSE 9096

COPY relay.toml /etc/

COPY influx-relay entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

CMD ["influx-relay", "-config", "/etc/relay.toml"]
