#!/bin/sh

# This script creates a branch that will be served via GitHub Pages.
#
# While creating the branch, files will be re-organized and many files
# will be deleted because they are not needed when serving HTML pages.


# Exit on error
set -e

GITPAGES_BRANCH=gitpages
CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

# Ensure we are in the git root directory
if [ `pwd` != `git rev-parse --show-toplevel` ]
then
    echo Error: This script must be run from the git root
    echo Error: directory. e.g. "'"./bin/$0"'"
    exit 1
fi



if [ "$CURRENT_BRANCH" = "$GITPAGES_BRANCH" ]
then
    echo Error: You are currently on the "'""$GITPAGES_BRANCH""'" branch.
    echo Error: This script should not be run while on that branch.
    echo Error: Please switch to another branch and rerun this script.
    echo Error: To switch to the 'main' branch: "'"git checkout main"'"
    exit 1
else
    # Delete branch if it exists
    git branch --delete "$GITPAGES_BRANCH" 2>/dev/null || true

    # Create branch
    git checkout -b "$GITPAGES_BRANCH"

    # Clean
    rm -f index.html

    # Rebuild
    cp ./jasper.html ./index.html

    rm -rf bin
    rm -f LICENSE.txt
    rm -f README.md
    rm -f jasper.html

    # Add changes and commit branch
    git add --all
    git commit -m "Construct gitpages branch"

    # Remove files created for the 'gitpages' branch
    rm -f ./index.html

    # Return to original branch
    git checkout "$CURRENT_BRANCH"
fi
