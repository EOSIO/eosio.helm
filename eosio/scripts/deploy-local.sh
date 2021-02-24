#!/bin/bash
set -eo pipefail
echo '--- :evergreen_tree: Configuring Environment'
cd $(dirname "$0")/..
./scripts/script.sh '-f local.yaml -f nodeos_config.yaml' local
echo 'Done.'
