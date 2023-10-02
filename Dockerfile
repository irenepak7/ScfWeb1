FROM buildpack-deps:bullseye

LABEL maintainer="Sebastian Ramirez <tiangolo@gmail.com>"

RUN apt-get update && \
    apt install libnginx-mod-rtmp ufw curl

COPY nginx.conf /etc/nginx/nginx.conf
# COPY default /etc/nginx/sites-enabled/default
RUN ufw allow 1935/tcp && service nginx restart
EXPOSE 1935
CMD ["nginx", "-g", "daemon off;"]
