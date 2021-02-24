#!/bin/bash
set -eo pipefail
echo '--- :evergreen_tree: Configuring Environment'
cd $(dirname "$0")/..
scripts/script.sh '-f primary.yaml -f nodeos_config.yaml' primary
echo 'Done.'
