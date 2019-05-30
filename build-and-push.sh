#!/bin/bash

set -eu

project="${1:-$(gcloud config get-value project | tr : /)}"
: "${project:?no project}"

docker build -t "gcr.io/${project}/dns-echo" image/
docker push "gcr.io/${project}/dns-echo"

