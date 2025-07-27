#!/bin/bash

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