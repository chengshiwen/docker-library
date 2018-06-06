FROM alpine:3.7

RUN apk add --no-cache ncftp \
 && rm -rf /var/cache/apk/*

WORKDIR /ncftp

CMD ["tail", "-f", "/dev/null"]
