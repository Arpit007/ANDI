# Build Stage
ARG NGINX_VERSION=1.18.0

FROM alpine:3.12.0 AS build

ARG NGINX_VERSION

RUN apk update \
    && apk add build-base \
        linux-headers\
        openssl-dev \
        pcre-dev \
        zlib-dev \
        geoip-dev

WORKDIR /app

COPY build.sh .

RUN chmod +x build.sh && \
    ./build.sh


# Final Stage
FROM alpine:3.12.0

ARG NGINX_VERSION

LABEL maintainer="admin@admin.com" \
    nginx.version=${NGINX_VERSION} \
    alpine.version=3.12.0

RUN apk update \
    && apk add \
        linux-headers\
        openssl \
        pcre \
        zlib \
        geoip \
    && mkdir -p /app

WORKDIR /app

RUN addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx 

USER nginx

COPY --from=build --chown=nginx:nginx /app/out /

COPY nginx.conf /usr/share/nginx/conf/nginx.conf

RUN ln -s /dev/stdout /var/log/nginx/access.log && \
    ln -s /dev/stderr /var/log/nginx/error.log && \
    mkdir -p /tmp/nginx/cache/body /tmp/nginx/cache/proxy

CMD ["nginx", "-g", "daemon off;"]