#!/bin/bash
set -eo pipefail
echo '+++ :yaml: Generating Pipeline Steps'
# pipeline.yml header
cat > pipeline.yml <<EOF
steps:
  - wait

EOF
# find all helm deployments
for HELM_DEPLOY_SCRIPT in $(find scripts -maxdepth 1 -name 'deploy*.sh'); do
    # echo "HELM_DEPLOY_SCRIPT='$HELM_DEPLOY_SCRIPT'"
    # derive deployment name from HELM_DEPLOY_SCRIPT path
    DEPLOYMENT_NAME="$(basename "$HELM_DEPLOY_SCRIPT" | sed 's/^deploy-//' | sed 's/\.sh$//')"
    cat >> pipeline.yml <<EOF

  - label: ":helm: Verify Helm Charts - $DEPLOYMENT_NAME"
    command: "$HELM_DEPLOY_SCRIPT"
    agents:
      queue: "automation-eks-helm3-deployer-fleet"
    concurrency: 1
    concurrency_group: "eosio-helm-$BUILDKITE_BRANCH-$DEPLOYMENT_NAME"
EOF
done
[[ "$DEBUG" == 'true' && "$BUILDKITE" == 'true' ]] && buildkite-agent artifact upload pipeline.yml
echo '+++ :pipeline_upload: Deploying Pipeline Steps'
[[ "$BUILDKITE" == 'true' ]] && buildkite-agent pipeline upload pipeline.yml # this must be last
echo '+++ :white_check_mark: Done! Good luck :)'
