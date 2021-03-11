#!/bin/bash
set -eo pipefail
echo '+++ :helm: Executing Helm package release.'

bucket="$EOSIO_HELM_CHART_REPO_BUCKET"
if [[ "$BUILDKITE_BRANCH" != 'master' ]]; then
    bucket="$EOSIO_HELM_CHART_REPO_TEST_BUCKET"
fi

command="test -n \"$bucket\""
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
if [[ -n `aws s3 ls s3://$bucket/$index` ]]; then
    command="aws s3 cp s3://$bucket/$index $original_index"
    echo $command
    eval $command
fi

for package in `ls -f *.tgz`; do
    if [[ ! -f $original_index || -z `cat $original_index | grep $package` ]]; then
        echo "Uploading package to repo."
        command="aws s3 cp $package s3://$bucket"
        if [[ -z "$DRY_RUN" ]]; then
            eval $command
        else
	    echo "Skipping \"$command\""
        fi
    else
        echo "Not indexing package that already exists in the repo."
        command="rm $package"
        echo $command
        eval $command
    fi
done

echo ""
echo "- Building updated index."
if [[ -f $original_index ]]; then
    command="helm repo index --merge $original_index ."
else
    command="helm repo index ."
fi
echo $command
eval $command

artifacthub_metadata="artifacthub-repo.yml"
command="aws s3 cp $artifacthub_metadata s3://$bucket/$artifacthub_metadata"
echo $command
if [[ -z "$DRY_RUN" ]]; then
    eval $command
else
    echo "Skipping \"$command\""
fi

command="aws s3 cp $index s3://$bucket/$index"
echo $command
if [[ -z "$DRY_RUN" ]]; then
    eval $command
else
    echo "Skipping \"$command\""
fi

echo '+++ :white_check_mark: Done! Good luck :)'
