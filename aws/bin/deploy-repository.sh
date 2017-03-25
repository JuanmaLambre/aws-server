#!/bin/bash

#
# Usage:
#   deploy-repository [OPTIONS]
#
# Options:
#   --local-commit      Deploys not from last pushed commit but from last local commit
#   --current-branch    Deploys from current branch and not from master
#

source args-parser.sh

parse_args $@


# Get last master commit ID
REMOTE=$(test -z $ARG_LOCAL_COMMIT && echo '' || echo 'origin/')
BRANCH=$(test -z $ARG_CURRENT_BRANCH && echo $(git rev-parse --abbrev-ref HEAD) || echo master)
COMMIT_ID=$(git rev-parse $REMOTE$BRANCH)

# Do deployment
DEPLOY_RESP=$(aws deploy create-deployment \
        --application-name juanma-app \
        --deployment-group-name default-deploygroup\
        --github-location repository=JuanmaLambre/aws-server,commitId=$COMMIT_ID)

if [ $? ]; then
    echo Deploy in progress
    echo Check at "https://us-west-2.console.aws.amazon.com/codedeploy/home?region=us-west-2#/deployments/$(echo $DEPLOY_RESP | jq .deploymentId | grep -oE '[^\"]*')"
else
    echo Deploy failed
    echo $DEPLOY_RESP
fi
