rm -R source
cp -R ./.references/euclid-development-environment/source source
scripts/hydra install
scripts/hydra build --no_cache
scripts/hydra start_genesis

scripts/hydra stop
scripts/hydra destroy