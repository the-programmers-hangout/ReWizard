FROM ubuntu:latest
RUN mkdir /app
RUN apt-get update && apt-get -y install libssl-dev
COPY _build/prod/rel/rewizard /app
CMD ["/app/bin/rewizard", "start"]
