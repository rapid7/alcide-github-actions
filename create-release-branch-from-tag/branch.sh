#!/usr/bin/env bash

source $(dirname "$0")/common.sh

BRANCH_NAME=$1
COMMIT_SHA=$2

function configureNewBranch()
{
    local commitId=$1

    echo "##########################"
    echo "Branching from commit id: $commitId"
    echo "##########################"

    #branchSplitName="${BRANCH_NAME}_branch_split"
    branchHotfixName="${BRANCH_NAME}_hotfix"

    echo "Checkout branch: $BRANCH_NAME"
    git branch $BRANCH_NAME $commitId || error "can't checkout branch: ${BRANCH_NAME}, commit: $commitId"
    echo "Pushing new branch: $BRANCH_NAME to remote"
    git push -u origin refs/heads/${BRANCH_NAME}:refs/heads/${BRANCH_NAME} || error "can't push branch: $BRANCH_NAME to remote"

    #echo "Tagging branch split point on master"
    #git tag -a $branchSplitName $commitId -m "tag ${BRANCH_NAME} split point from master with tag: $branchSplitName" || error "failed to create tag: $branchSplitName"
    #git push origin $branchSplitName || error "can't push tag: $branchSplitName to remote"

    echo "Checkout new $branchHotfixName branch"
    git branch $branchHotfixName $commitId || error "can't create branch: $branchHotfixName from: ${BRANCH_NAME}"
    echo "Pushing new branch: $branchHotfixName to remote"
    git push origin $branchHotfixName || error "can't push branch:  $branchHotfixName"

    echo "finish branching project"
    echo "##########################"

}

function gitConfig()
{
    echo "Configuring git creds"
    git config --global user.name "alcide jenkins"
    git config --global user.email "alcidejenkins@rapid7.com"
}

echo "BRANCH_NAME: $BRANCH_NAME"
echo "COMMIT_SHA: $COMMIT_SHA"

gitConfig
if [ -z "${COMMIT_SHA}" ]; then
    echo "COMMIT_SHA is empty"
else
    configureNewBranch ${COMMIT_SHA}
fi
