#!/usr/bin/env bash

TASK_PATH="$1"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Add mocks to the beginning of task step script
yq -i '.spec.steps[2].script = load_str("'$SCRIPT_DIR'/mocks.sh") + .spec.steps[2].script' "$TASK_PATH"

# Create a dummy pyxis secret (and delete it first if it exists)
kubectl delete secret test-create-pyxis-image-cert --ignore-not-found
kubectl create secret generic test-create-pyxis-image-cert --from-literal=cert=mycert --from-literal=key=mykey
