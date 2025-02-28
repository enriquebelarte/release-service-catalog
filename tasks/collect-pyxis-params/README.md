# collect-pyxis-params

Tekton task that collects pyxis configuration options from the data file. The task looks at the data file
in the workspace to extract the `server` and `secret` keys for Pyxis. These are both emitted as task results
for downstream tasks to use.

## Parameters

| Name | Description | Optional | Default value |
|------|-------------|----------|---------------|
| dataPath | Path to the merged data JSON file generated by collect-data task and containing the pyxis configuration options to use | No | |

## Changes in 0.3.0
* Remove `dataPath` default value

## Changes in 0.2.1
* Update the description for `server` result

## Changes since 0.1.1
* Updated hacbs-release/release-utils image to reference redhat-appstudio/release-service-utils image instead

## Changes since 0.1.0
* Added `-j` to `jq` commands that output to results to remove trailing new lines
