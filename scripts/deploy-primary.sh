#!/bin/bash
set -eo pipefail
echo '--- :evergreen_tree: Configuring Environment'
./scripts/script.sh '-f primary.yaml' primary
echo 'Done.'
