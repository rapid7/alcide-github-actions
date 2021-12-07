#!/usr/bin/env bash

source $(dirname "$0")/common.sh

VERSION_NAME=$1
GIT_USER_NAME=$2
GIT_USER_EMAIL=$3
GITHUB_TOKEN=$4

cd /home/runner/work/test-divvy/test-divvy/main
pwd
function configureNewBranch()
{
    local sourceBranch=$1
    local shortBranchName=${sourceBranch#remotes/origin/}
    echo "#########################################"
    echo "Branching from source: $sourceBranch"
    echo "#########################################"
    date_merge=$(date +%Y%m%d)
    echo $date_merge
    branchReleaseName="mergeback__$shortBranchName-$date_merge"
    echo "gh auth status"
    gh auth status
    git checkout $sourceBranch
    echo "Checkout branch: $sourceBranch"
    git branch $branchReleaseName || error "can't checkout branch: $branchReleaseName, source: $sourceBranch"
    git checkout $branchReleaseName
    echo "finish branching project, pushing to repo"
    git push -u origin $branchReleaseName || error "can't push branch: $branchReleaseName to remote"
    echo "Creating pull request with reviewers:"
    gh pr create --title $branchReleaseName --body "automatically created because changes detected" --reviewer mrotman-r7,ahoze-r7,ashapira-r7,rjackoby-r7 --head $branchReleaseName --base development
    #echo "Creating auto merge for pull request"
    #gh pr merge $branchReleaseName --auto -m
    echo "finished creating pull request"
    echo "##########################"

}

function gitConfig()
{
    echo "Configuring git creds"
    git config --global user.name $GIT_USER_NAME
    git config --global user.email $GIT_USER_EMAIL
    echo "$GITHUB_TOKEN" > .githubtoken
    gh auth login --with-token < .githubtoken
}

echo "VERSION_NAME: $VERSION_NAME"
echo "GIT_USER_NAME: $GIT_USER_NAME"
echo "GIT_USER_EMAIL: $GIT_USER_EMAIL"

gitConfig
echo "Checking if development branch is up to date"
branchDiff=(git diff $VERSION_NAME..main)
echo "contents of $branchDiff"
if [ -z "${VERSION_NAME}" ]; then
    echo "COMMIT_SHA is empty"
elif [ ! -z "$branchDiff" ]; then
  configureNewBranch ${VERSION_NAME}
else
    echo "Dev branch up to date."
fi
