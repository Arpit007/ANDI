#!/bin/sh

echo "Fetching Nginx ${NGINX_VERSION}"

mkdir -p /app/src /app/out

wget -c http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -O - | tar -xz -C src --strip-components=1

cd src

./configure \
        --with-cc-opt='-g -O2 -fdebug-prefix-map=/build/nginx-5J5hor/nginx-${NGINX_VERSION}=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
        --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/local/bin/nginx \
        --modules-path=bin/modules \
        --conf-path=conf/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/tmp/nginx.pid \
        --lock-path=/var/lock/nginx.lock \
        --build=Nginx:Stark:${NGINX_VERSION} \
        --with-threads \
        --with-file-aio \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_geoip_module=dynamic \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_auth_request_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --without-http_autoindex_module \
        --without-http_split_clients_module \
        --without-http_referer_module \
        --without-http_fastcgi_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --without-http_grpc_module \
        --without-http_empty_gif_module \
        --without-http_browser_module \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx/cache/body \
        --http-proxy-temp-path=/tmp/nginx/cache/proxy \
        --with-stream=dynamic \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --without-stream_map_module \
        --without-stream_split_clients_module \
        --with-pcre \
        --with-compat

make

make DESTDIR=../out install