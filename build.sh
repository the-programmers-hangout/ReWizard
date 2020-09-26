#!/bin/sh
rm -rf _build
env MIX_ENV=prod mix release
docker build -t rewizard .
