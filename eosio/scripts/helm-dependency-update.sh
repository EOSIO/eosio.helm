#!/bin/bash
set -eo pipefail

# Order here matters
DEP_TREE=('eosio-common' 'eosio-nodeos' 'eosio')

for chart in "${DEP_TREE[@]}"; do
  pushd $chart
  helm dependency update
  popd
done
