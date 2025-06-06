#!/usr/bin/env bash

TASK_PATH="$1"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Create a dummy pyxis secret (and delete it first if it exists)
kubectl delete secret test-push-rpm-data-to-pyxis-cert --ignore-not-found
kubectl create secret generic test-push-rpm-data-to-pyxis-cert --from-literal=cert=mycert --from-literal=key=mykey

# Add mocks to the beginning of scripts
yq -i '.spec.steps[2].script = load_str("'$SCRIPT_DIR'/mocks.sh") + .spec.steps[2].script' "$TASK_PATH"
yq -i '.spec.steps[3].script = load_str("'$SCRIPT_DIR'/mocks.sh") + .spec.steps[3].script' "$TASK_PATH"
