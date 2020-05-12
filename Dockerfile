FROM alpine:3.11

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
        && apk update \
        && apk add --no-cache --virtual .build-deps \
                build-base \
                cmake \
                make \
                boost-dev \
                openssl-dev \
                mariadb-connector-c-dev \
                git \
        && (git clone https://github.com/trojan-gfw/trojan.git \
        && cd trojan \
        && cmake . \
        && make \
        && strip -s trojan \
        && mv trojan /usr/bin) \
        && rm -rf trojan \
        && apk del .build-deps \
        && apk add --no-cache --virtual .trojan-rundeps \
                libstdc++ \
                boost-system \
                boost-program_options \
                mariadb-connector-c

WORKDIR /config
CMD ["trojan", "config.json"]
