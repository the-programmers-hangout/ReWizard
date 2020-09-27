# Rewizard

Rewizard is a regex evaluation bot for discord.

It expects the following environmental variables to exist.

```
REWIZARD_TOKEN=...
REWIZARD_CHANNEL=...
REWIZARD_RATE_LIMIT=...
```

Rewizard will only work in the *single* channel it is assigned to,
it will rate limit all users and attach an emoji for repeated spamming.

All replies are Embeds so it shouldn't trigger other bots.


## Deployment

There is a multi stage docker file included that will build out a runnable container.

```
$ docker build -t rewizard .
$ docker run --env-file=./env rewizard
```
