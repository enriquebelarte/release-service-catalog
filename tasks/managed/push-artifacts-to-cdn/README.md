# push-artifacts-to-cdn

Tekton task to push artifacts via an InternalRequest to Exodus CDN in addition to Developer Portal.
The environment to use is pulled from the `cdn.env` key in the data file.

## Parameters

| Name                     | Description                                                                               | Optional | Default value |
|--------------------------|-------------------------------------------------------------------------------------------|----------|---------------|
| releasePath              | Path to the release data JSON file                                                        | No       | -             |
| snapshotPath             | Path to the JSON file of the Snapshot spec in the data workspace                          | No       | -             |
| dataPath                 | Path to data JSON in the data workspace                                                   | No       | -             |
| releasePlanAdmissionPath | Path to the JSON string of the releasePlanAdmission in the data workspace                 | No       | -             |
| pipelineRunUid           | The uid of the current pipelineRun. Used as a label value when creating internal requests | No       | -             |
| taskGitUrl               | The url to the git repo where the release-service-catalog tasks to be used are stored     | No       | -             |
| taskGitRevision          | The revision in the taskGitUrl repo to be used                                            | No       | -             |
| resultsDirPath           | Path to results directory in the data workspace                                           | No       | -             |
| requestTimeout           | Request timeout                                                                           | Yes      | 86400         |

## Changes in 2.0.0
* task now extracts the signing key name from the config map and passes it to the internalRequest

## Changes in 1.0.1
* The default serviceAccount is changed from `appstudio-pipeline` to `release-service-account`

## Changes in 1.0.0
* `releasePath` parameter added
  * Author is extracted from the Release.Status and passed to the internalRequest

## Changes in 0.0.2
* release-service-utils image is bumped
* task now creates InternalRequests using the Git Ref of the internal pipeline instead of the cluster pipeline name
