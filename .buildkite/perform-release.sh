#!/bin/bash
set -eo pipefail
echo '+++ :helm: Executing Helm package release.'

command="test -n \"$EOSIO_HELM_CHART_REPO_BUCKET\""
echo $command
eval $command

echo ""
echo "- Updating subcharts."
command="./eosio/scripts/helm-dependency-update.sh"
echo $command
eval $command

echo ""
echo "- Packaging charts."
for directory in `ls -d eosio*`; do
  # TODO sign these packages
  command="helm package $directory"
  echo $command
  eval $command
done

original_index="index.yaml.orig"
index="index.yaml"

echo ""
echo "- Evaluating existing repo index."
command="aws s3 cp s3://$EOSIO_HELM_CHART_REPO_BUCKET/$index $original_index"
echo $command
eval $command

for package in `ls -f *.tgz`; do
  if [[ -z `cat $original_index | grep $package` ]]; then
    echo "Uploading package to repo."
    command="aws s3 cp $package s3://$EOSIO_HELM_CHART_REPO_BUCKET"
    echo $command
    eval $command
  else
    echo "Not indexing package that already exists in the repo."
    command="rm $package"
    echo $command
    eval $command
  fi
done

echo ""
echo "- Building updated index."
command="helm repo index --merge $original_index ."
echo $command
eval $command

command="aws s3 cp $index s3://$EOSIO_HELM_CHART_REPO_BUCKET/$index"
echo $command
eval $command

echo '+++ :white_check_mark: Done! Good luck :)'
