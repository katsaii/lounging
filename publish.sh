#!/bin/bash

if ! [[ $* = *--no-build* ]]
then
    if ! ./build.sh --release
    then
        echo "failed to build (see output)"
        exit 1
    fi
else
    echo "skipping build"
fi

artdir=webring

# clear previous deployments
# thank you: https://github.com/orgs/community/discussions/85000#discussioncomment-9284450
if command -v "gh" &> /dev/null
then
    for ID in $(gh api -X GET /repos/{owner}/{repo}/deployments | jq -r ".[] | .id")
    do
        echo "deleting deployment $ID"
        gh api -X DELETE /repos/{owner}/{repo}/deployments/$ID | jq '.'
    done
else
    echo "'gh' command not installed: skipping deployments"
fi

# create and publish gh-pages branch
# adapts code heavily from: https://matthew-brett.github.io/pydagogue/gh-pages-intro.html
if command -v git &> /dev/null
then
    if ! [[ -z "$(git status -s)" ]]
    then
        echo "[ERROR!] commit or stash your local changes before calling ./publish.sh"
        exit 2
    fi

    brdest=gh-pages
    brcurr=$(git rev-parse --abbrev-ref HEAD)
    dt=$(date '+%d/%m/%Y %H:%M:%S')

    if git branch -D $brdest &> /dev/null
    then
        echo "\ndeleted old '$brdest' branch"
    fi

    echo "creating '$brdest' branch"
    git checkout --orphan $brdest
    git reset --hard
    #git clean -fxd

    if [ -d $artdir ]
    then
        echo "moving artifacts into repo root directory"
        mv webring/* ./
        rmdir webring

        echo "committing changes"
        git add .
        git commit -m "publish $dt"
        git push origin $brdest --force
    else
        echo "missing 'webring' directory (did you run ringfairy?)"
    fi

    echo "resetting to '$brcurr' branch"
    git checkout $brcurr

    echo "done! welcome to the loungeware nation"
fi