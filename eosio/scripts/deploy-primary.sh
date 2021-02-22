#!/bin/bash
set -eo pipefail
echo '--- :evergreen_tree: Configuring Environment'
cd $(dirname "$0")/..
scripts/script.sh '-f primary.yaml' primary
echo 'Done.'
