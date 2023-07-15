FROM alpine:latest AS BUILD

MAINTAINER Gustavo Angulo <woakas@ubidots.com>

RUN apk --no-cache add readline readline-dev libconfig libconfig-dev lua \
                       lua-dev luajit-dev luajit openssl-dev libgcrypt-dev \
                       build-base libevent libevent-dev python3-dev \
                       jansson jansson-dev zlib-dev git
RUN git clone --recursive https://github.com/kenorb-contrib/tg.git /tg

WORKDIR /tg
RUN ./configure --disable-openssl && make

# Binary telegram-cli
FROM alpine:latest

RUN apk add --no-cache libevent jansson libconfig libexecinfo \
                       readline lua libgcrypt
RUN adduser -D telegramd
RUN mkdir -p /home/telegramd/.telegram-cli ; chown -R telegramd:telegramd /home/telegramd/.telegram-cli

VOLUME ["/home/telegramd/.telegram-cli"]
COPY --from=build /tg/bin/telegram-cli /bin/telegram-cli

EXPOSE 2391

CMD telegram-cli

