#!/bin/bash


lbs=($(
  kubectl get svc -o json \
    | jq -r '.items[] | select (.metadata.name | startswith("dns")) | .status.loadBalancer.ingress[].ip'))

while sleep 1; do
  l="${lbs[RANDOM % ${#lbs[@]}]}"
  echo "$l $(dig sausages txt @"$l" +short)"
done

