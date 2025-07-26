#!/bin/bash

for ID in $(gh api -X GET /repos/{owner}/{repo}/deployments | jq -r ".[] | .id")
do 
  echo "Deleting deployment $ID"
  gh api -X DELETE /repos/{owner}/{repo}/deployments/$ID | jq '.'
done


