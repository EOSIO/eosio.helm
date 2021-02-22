#!/bin/bash
set -eo pipefail
echo '--- :evergreen_tree: Configuring Environment'
./scripts/script.sh '-f local.yaml' local
echo 'Done.'
