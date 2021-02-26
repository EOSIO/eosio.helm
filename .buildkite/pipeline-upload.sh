#!/bin/bash
set -eo pipefail
echo '+++ :yaml: Generating Pipeline Steps'
# pipeline.yml header
cat > pipeline.yml <<EOF
steps:
  - wait

EOF

SCRIPT_PATH='eosio/scripts'

# find all helm deployments
for HELM_DEPLOY_SCRIPT in $(find "$SCRIPT_PATH" -maxdepth 1 -name 'deploy*.sh'); do
    # echo "HELM_DEPLOY_SCRIPT='$HELM_DEPLOY_SCRIPT'"
    # derive deployment name from HELM_DEPLOY_SCRIPT path
    DEPLOYMENT_NAME="$(basename "$HELM_DEPLOY_SCRIPT" | sed 's/^deploy-//' | sed 's/\.sh$//')"
    cat >> pipeline.yml <<EOF

  - label: ":helm: Verify Helm Charts - $DEPLOYMENT_NAME"
    command: "$SCRIPT_PATH/helm-dependency-update.sh && $HELM_DEPLOY_SCRIPT"
    agents:
      queue: "automation-eks-helm3-deployer-fleet"
    concurrency: 1
    concurrency_group: "eosio-helm-$BUILDKITE_BRANCH-$DEPLOYMENT_NAME"
EOF
done

cat >> pipeline.yml <<EOF
  - wait

  - label: ":helm: Release Helm Chart updates."
    command: ".buildkite/perform-release.sh"
    agents:
      queue: "automation-eks-helm3-deployer-fleet"
    concurrency: 1
    concurrency_group: "eosio-helm-$BUILDKITE_BRANCH"
EOF

[[ "$DEBUG" == 'true' && "$BUILDKITE" == 'true' ]] && buildkite-agent artifact upload pipeline.yml
echo '+++ :pipeline_upload: Deploying Pipeline Steps'
[[ "$BUILDKITE" == 'true' ]] && buildkite-agent pipeline upload pipeline.yml # this must be last
echo '+++ :white_check_mark: Done! Good luck :)'
