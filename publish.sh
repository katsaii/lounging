#!/bin/bash

if ! [[ $* = *--no-build* ]]
then
    if ! ./build.sh --release
    then
        echo
        echo "failed to build (see output)"
        exit 1
    fi
else
    echo
    echo "skipping build"
fi

artcname="www.loungeware.club"
artdir=webring

# create and publish gh-pages branch
# adapts code heavily from: https://matthew-brett.github.io/pydagogue/gh-pages-intro.html
if command -v git &> /dev/null
then
    if ! [[ -z "$(git status -s)" ]]
    then
        echo
        echo "[ERROR!] commit or stash your local changes before calling ./publish.sh"
        exit 2
    fi

    brdest=gh-pages
    brcurr=$(git rev-parse --abbrev-ref HEAD)
    dt=$(date '+%d/%m/%Y %H:%M:%S')

    if git branch -D $brdest &> /dev/null
    then
        echo
        echo "deleted old '$brdest' branch"
    fi

    echo
    echo "creating '$brdest' branch"
    git checkout --orphan $brdest
    git reset --hard
    #git clean -fxd

    if [ -d $artdir ]
    then
        echo
        echo "moving artifacts into repo root directory"
        mv webring/* ./
        rmdir webring

        echo
        echo "adding CNAME"
        echo $artcname > CNAME

        echo
        echo "committing changes"
        git add .
        git commit -m "publish $dt"
        git push origin $brdest --force
    else
        echo
        echo "missing 'webring' directory (did you run ringfairy?)"
    fi

    echo
    echo "resetting to '$brcurr' branch"
    git checkout $brcurr

    echo
    echo "done! welcome to the loungeware nation"
fi