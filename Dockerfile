FROM elixir as build

WORKDIR /build

COPY mix.exs .
COPY mix.lock .
COPY lib lib
COPY config config

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN env MIX_ENV=prod mix release

FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && apt-get -y install libssl-dev locales && rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

COPY --from=build /build/_build/prod/rel/rewizard /app

CMD ["/app/bin/rewizard", "start"]
