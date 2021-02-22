#!/bin/bash
set -eo pipefail
[[ "$BUILDKITE_PIPELINE_SLUG" == 'eosio-dot-helm' || ! -z "$DRY_RUN" ]] && export DRY_RUN='true'

# lint
echo '+++ :lint-roller: Helm Lint'
HELM_LINT="helm lint $1"
echo "$ $HELM_LINT"
eval $HELM_LINT

# diff
echo '+++ :arrows_counterclockwise: Helm Diff'
HELM_DIFF="helm diff upgrade $2 . $1 --allow-unreleased"
echo "$ $HELM_DIFF"
eval $HELM_DIFF

# install
echo '+++ :helm: Helm Install'
HELM_INSTALL="helm upgrade --install $2 . $([[ "$DRY_RUN" != 'true' ]] || echo ' --dry-run') $1"
echo "$ $HELM_INSTALL"
eval $HELM_INSTALL
