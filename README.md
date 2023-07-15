# Docker container for Telegram CLI

Container for https://github.com/vysheng/tg

## Building

```
docker build -t telegram-cli .
```

## Deployment

To set up telegram-cli for the first time:

```
bash -c 'docker run -it --rm -v $(pwd)/telegram-cli/config:/home/telegramd/.telegram-cli/config telegram-cli'
```

Then run docker container as a service, as usual:

```
docker-compose up -d
```

