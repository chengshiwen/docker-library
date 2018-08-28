FROM alpine:3.7

RUN apk add --no-cache ca-certificates

EXPOSE 7076

COPY influx-proxy entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

CMD ["influx-proxy"]
