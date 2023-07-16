FROM alpine:3.18 AS BUILD

MAINTAINER Gustavo Angulo <woakas@ubidots.com>

RUN apk --no-cache add readline readline-dev libconfig libconfig-dev lua \
                       lua-dev luajit-dev luajit openssl-dev libgcrypt-dev \
                       build-base libevent libevent-dev python3-dev \
                       jansson-static jansson-dev zlib-dev git cmake
RUN git clone --recursive https://github.com/vysheng-telegram-cli/telegram-cli.git /tg

WORKDIR /tg
RUN cmake . && cmake --build .

# Binary telegram-cli
FROM alpine:3.18

RUN apk add --no-cache libevent jansson libconfig \
                       readline lua-libs libgcrypt
RUN adduser -D telegramd
RUN mkdir -p /home/telegramd/.telegram-cli ; chown -R telegramd:telegramd /home/telegramd/.telegram-cli

VOLUME ["/home/telegramd/.telegram-cli"]
COPY --from=build /tg/telegram-cli /usr/bin/telegram-cli

EXPOSE 2391

CMD telegram-cli

