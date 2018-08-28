FROM nginx:alpine

LABEL maintainer=chengshiwen<chengshiwen0103@gmail.com>

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
