#!/bin/bash

scripts/hydra stop
scripts/hydra destroy
docker container prune -f
sudo rm -R source
cp -R ./.references/euclid-development-environment/source source
scripts/hydra install
scripts/hydra build
scripts/hydra start_genesis