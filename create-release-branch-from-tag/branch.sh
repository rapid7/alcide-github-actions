#!/usr/bin/env bash

source $(dirname "$0")/common.sh

TAG_NAME=$1
COMMIT_SHA=$2
GIT_USER_NAME=$3
GIT_USER_EMAIL=$4

function configureNewBranch()
{
    local commitId=$1

    echo "##########################"
    echo "Branching from commit id: $commitId"
    echo "##########################"

    branchReleaseName="release/${TAG_NAME}"

    echo "Checkout branch: $TAG_NAME"
    git branch $branchReleaseName $commitId || error "can't checkout branch: $branchReleaseName, commit: $commitId"
    echo "Pushing new branch: $TAG_NAME to remote"
    git push -u origin $branchReleaseName || error "can't push branch: $branchReleaseName to remote"

    echo "finish branching project"
    echo "##########################"

}

function gitConfig()
{
    echo "Configuring git creds"
    git config --global user.name $GIT_USER_NAME
    git config --global user.email $GIT_USER_EMAIL
}

echo "TAG_NAME: $TAG_NAME"
echo "COMMIT_SHA: $COMMIT_SHA"
echo "GIT_USER_NAME: $GIT_USER_NAME"
echo "GIT_USER_EMAIL: $GIT_USER_EMAIL"

gitConfig
if [ -z "${COMMIT_SHA}" ]; then
    echo "COMMIT_SHA is empty"
else
    configureNewBranch ${COMMIT_SHA}
fi
