#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Check if the current folder contains .git folder and is active GIT repo
if [[ -z $(git rev-parse --is-inside-work-tree 2> /dev/null || false) ]]; then
    echo -e "${RED}Your not in a GIT repository${RESET}"
    exit 1;
fi

echo -e "${GREEN}Enter new tag version${RESET} (e.g. 1.0.1 or 1.1.2)"
printf "> "
read VERSION

echo
echo -e "${GREEN}Enter new dependency version${RESET} (e.g. 1.0.* or 1.1.* or ^1.1.2)"
echo -e "${DIM}Version for dependencies as composer allows.${RESET}"
printf "> "
read DEPENDENCIES_VERSION


# Check if the current branch is master
CURRENT_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
if [[ $CURRENT_BRANCH == 'master' ]];
then
    MERGE_INTO_MASTER=false
else
    echo
    echo -e "${GREEN}Do you want to merge current branch \"$CURRENT_BRANCH\" into the master?${RESET} (y|Y|n|N) default: n"
    printf "> "
    read -n 1 -r MERGE_INTO_MASTER
fi

# Want to merge current branch into the master branch?
# This is usefull incase from develop to master
if [[ $MERGE_INTO_MASTER =~ ^[Yy]$ ]];
then
    echo
    echo -e "${GREEN}Do you want to update composer.json dependencies section to dev-master?${RESET} (y|Y|n|N) default: n "
    printf "> "
    read -n 1 -r UPDATE_DEPENDENCIES_FOR_MERGE

    echo
    echo "Lets start the process"
    echo

    echo "Pull latest changes of the branch: $CURRENT_BRANCH"
    git pull origin $CURRENT_BRANCH  >/dev/null 2>/dev/null

    if [[ $UPDATE_DEPENDENCIES_FOR_MERGE =~ ^[Yy]$ ]];
    then
        sed "s/[(bp|qq).laravel.(.*)\":\s\"]dev-$CURRENT_BRANCH[\"]/\"dev-master\"/g" composer.json > tmp.json && mv tmp.json composer.json
        git commit -am "Changed composer.json dependencies to dev-master"  >/dev/null 2>/dev/null
    fi
else
    echo
    echo "Lets start the process"
    echo
fi

# Suspress output: >/dev/null 2>/dev/null
# Get latest version from master
echo "Fetch latest versions and commits from origin: master"
git fetch origin  >/dev/null 2>/dev/null
git checkout master  >/dev/null 2>/dev/null
git pull origin master  >/dev/null 2>/dev/null

if [[ $MERGE_INTO_MASTER =~ ^[Yy]$ ]];
then
    git merge $CURRENT_BRANCH

    if [[ -n $(git ls-files --unmerged) ]]; then
        echo
        echo -e "${RED}Please fix the merge conflicts first and run again.${RESET}"
        exit 1;
    fi
fi

echo "Create new version: $VERSION"

# Open composer.json and rename all bp.laravel.* dev-master to a version
sed "s/[(bp|qq).laravel.(.*)\":\s\"]dev-master[\"]/\"$DEPENDENCIES_VERSION\"/g" composer.json > tmp.json && mv tmp.json composer.json
sed "s/ - Unreleased//g" CHANGELOG.md > bck_CHANGELOG.md && mv bck_CHANGELOG.md CHANGELOG.md

# Ask if you want to update the composer.lock / dependencies
echo
echo -e "${GREEN}Want to update the composer.lock dependencies from the dev-master?${RESET} (y|Y|n|N) default: n "
printf "> "
read -n 1 -r UPDATE_DEPENDENCIES

echo
echo

# update dependencies to version number
if [[ $UPDATE_DEPENDENCIES =~ ^[Yy]$ ]];
then
    echo "Update dependencies to latest versions"
    composer update --no-dev  >/dev/null 2>/dev/null
fi

# commit the updated version numbers in composer.json
git commit -am "Release version $VERSION"  >/dev/null 2>/dev/null

# create tags and remove old once
git tag -d $VERSION  >/dev/null 2>/dev/null
git tag $VERSION  >/dev/null 2>/dev/null

# Push commit and tags to the server
git push origin master  >/dev/null 2>/dev/null
git push origin --tags --force  >/dev/null 2>/dev/null
echo "Push new version to remote"

echo "Create new dev-master based on $VERSION"
# Create develop version
sed "s/[(bp|qq).laravel.(.*)\":\s\"]$DEPENDENCIES_VERSION[\"]/\"dev-master\"/g" composer.json > tmp.json && mv tmp.json composer.json

# Push commit to the sever
git commit -am "Create dev-master version based on $VERSION." >/dev/null 2>/dev/null

echo "Push the new dev-master version to remote"
git push origin master
