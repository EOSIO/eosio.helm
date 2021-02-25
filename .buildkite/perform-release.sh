#!/bin/bash
set -xeo pipefail
echo '+++ :helm: Executing Helm package release.'

test -n "$EOSIO_HELM_CHART_REPO_BUCKET"

./eosio/scripts/helm-dependency-update.sh

for directory in `ls -d eosio*`; do
  # TODO - sign these packages
  helm package $directory
done

for package in `ls -f *.tgz`; do
  aws s3 cp $package s3://$EOSIO_HELM_CHART_REPO_BUCKET
done

aws s3 cp s3://$EOSIO_HELM_CHART_REPO_BUCKET/index.yaml index.yaml.orig

helm repo index --merge index.yaml.orig .

aws s3 cp index.yaml s3://$EOSIO_HELM_CHART_REPO_BUCKET/index.yaml

echo '+++ :white_check_mark: Done! Good luck :)'
