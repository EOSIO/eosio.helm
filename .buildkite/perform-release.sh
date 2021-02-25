#!/bin/bash
set -xeo pipefail
echo '+++ :helm: Executing Helm package release.'

test -n "$EOSIO_HELM_CHART_REPO_BUCKET"

./eosio/scripts/helm-dependency-update.sh

for directory in `ls -d eosio*`; do
  # TODO - sign these packages
  helm package $directory
done

original_index="index.yaml.orig"
index="index.yaml"

aws s3 cp s3://$EOSIO_HELM_CHART_REPO_BUCKET/$index $original_index

for package in `ls -f *.tgz`; do
  if [[ -z `cat $original_index | grep $package` ]]; then
    aws s3 cp $package s3://$EOSIO_HELM_CHART_REPO_BUCKET
  else
    rm $package
  fi
done

helm repo index --merge $original_index .

aws s3 cp $index s3://$EOSIO_HELM_CHART_REPO_BUCKET/$index

echo '+++ :white_check_mark: Done! Good luck :)'
