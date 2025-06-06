# rh-sign-image

Task to create internalrequests or pipelineruns to sign snapshot components

## Parameters

| Name                     | Description                                                                                                                                                                                                                                       | Optional | Default value           |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|-------------------------|
| snapshotPath             | Path to the JSON string of the mapped Snapshot spec in the data workspace                                                                                                                                                                         | No       | -                       |
| dataPath                 | Path to the JSON string of the merged data to use in the data workspace                                                                                                                                                                           | No       | -                       |
| releasePlanAdmissionPath | Path to the JSON string of the releasePlanAdmission in the data workspace                                                                                                                                                                         | No       | -                       |
| requester                | Name of the user that requested the signing, for auditing purpose                                                                                                                                                                                 | No       | -                       |
| requestTimeout           | Request timeout                                                                                                                                                                                                                                   | Yes      | 1800                    |
| concurrentLimit          | The maximum number of images to be processed at once                                                                                                                                                                                              | Yes      | 16                      |
| pipelineRunUid           | The uid of the current pipelineRun. Used as a label value when creating a requests                                                                                                                                                                | No       | -                       |
| pyxisServer              | The server type to use. Options are 'production','production-internal,'stage-internal' and 'stage'.                                                                                                                                               | No       | ""                      |
| pyxisSecret              | The kubernetes secret to use to authenticate to Pyxis. It needs to contain two keys: key and cert                                                                                                                                                 | No       | -                       |
| signRegistryAccessPath   | The relative path in the workspace to a text file that contains a list of repositories that needs registry.access.redhat.com image references to be signed (i.e. requires_terms=true), one repository string per line, e.g. "rhtas/cosign-rhel9". | No       | -                       |
| ociStorage               | The OCI repository where the Trusted Artifacts are stored                                                                                                                                                                                         | Yes      | empty                   |
| ociArtifactExpiresAfter  | Expiration date for the trusted artifacts created in the OCI repository. An empty string means the artifacts do not expire                                                                                                                        | Yes      | 1d                      |
| trustedArtifactsDebug    | Flag to enable debug logging in trusted artifacts. Set to a non-empty string to enable                                                                                                                                                            | Yes      | ""                      |
| orasOptions              | oras options to pass to Trusted Artifacts calls                                                                                                                                                                                                   | Yes      | ""                      | 
| sourceDataArtifact       | Location of trusted artifacts to be used to populate data directory                                                                                                                                                                               | Yes      | ""                      |
| dataDir                  | The location where data will be stored                                                                                                                                                                                                            | Yes      | $(workspaces.data.path) |
| taskGitUrl               | The url to the git repo where the release-service-catalog tasks and stepactions to be used are stored                                                                                                                                             | No       | ""                      |
| taskGitRevision          | The revision in the taskGitUrl repo to be used                                                                                                                                                                                                    | No       | ""                      |

## Changes in 6.0.1
* The default serviceAccount is changed from `appstudio-pipeline` to `release-service-account`

## Changes in 6.0.0
* This task now supports Trusted artifacts

## Changes in 5.1.0
* The pipeline is called via git resolver now instead of cluster resolver
  * This was done by changing from `-r` to `--pipeline` in the `internal-request`/`internal-pipelinerun` call
  * The base image was updated to include this new functionality

## Changes in 5.0.3
* Increase `requestTimeout` value to 30 minutes
  * The internal-request/internal-pipeline is set to a timeout of 30 minutes, but the internal-request/internal-pipeline script
    was set to timeout after 3 minutes, which didn't make much sense.

## Changes in 5.0.2
* fix linting issues

## Changes in 5.0.1
* The default for `sign.request` is now always `simple-signing-pipeline` instead of being `hacbs-signing-pipeline`
  if using InternalRequests

## Changes in 5.0.0
* Added mandatory parameter `signRegistryAccessPath`.
  * The relative path in the workspace to a text file that contains a list of repositories
    that needs registry.access.redhat.com image references to be signed (i.e.
    requires_terms=true), one repository string per line, e.g. "rhtas/cosign-rhel9".
  * Only components for which the repository is included in the file will get
    the registry.access.redhat.com references signed.

## Changes in 4.0.0
* New mandatory parameter `releasePlanAdmissionPath`
* New `internal-pipelinerun` requestType mode which can be enabled for the case of private, internal clusters.
  * Use `.data.sign.requestType` to choose between `internal-request` and `internal-pipelinerun`
* Attempts to sign are now skipped if the manifest digest for a given repository have already been signed.

## Changes in 3.4.1
* Increased default `concurrentLimit` to 16 to make signing faster.

## Changes in 3.4.0
* Added changes in order to eliminate the `translate-delivery-repo` script because the
 `registry.redhat.io` and `registry.access.redhat.com ` repo are now available
 in snapshot with key `rh-registry-repo` and `registry-access-repo` respectively.

## Changes in 3.3.0
* This task now also signs the manifest list digest when processing a multi-arch image

## Changes in 3.2.0
* Updated the base image used in this task

## Changes in 3.1.1
* set -x in the task script for easier debugging

## Changes in 3.1.0
* added support for OCI artifacts.

## Changes in 3.0.0
* `images.pushSourceContainer` is no longer supported
* `commonTags` parameter removed in favor of component tags in the snapshot spec file

## Changes in 2.7.0
* Updated the base image used in this task

## Changes in 2.6.0
* The task now looks for tags in each component of the snapshot spec file and uses them instead of commonTags if any exist

## Changes in 2.5.0
* Add support for checking the `mapping` key for `pushSourceContainer`
  * Can be per component or in the `mapping.defaults` section
  * The legacy location of `images.pushSourceContainer` will be removed in a future version

## Changes in 2.4.0
* When pushing source containers, the origin is now determined using `$repo:${digest}.src` instead of `$repo:${git_sha}.src`
  that was used previously. This follows a change in the build service.
  * We now also push this new tag, so sign it as well.

## Changes in 2.3.0
* remove `dataPath` and `snapshotPath` default values

## Changes in 2.2.3
* Add `set -e` to the task script, so it can fail if the `wait-for-internal-request` script exits with a non-zero status code, when at
  least one of the InternalRequests has not succeeded

## Changes in 2.2.2
* An InternalRequest is now created to sign source containers

## Changes in 2.2.1
* An InternalRequest is now created to sign the both the registry.redhat.io and registry.access.redhat.com references
  * This change comes with a bump in the image used for the task

## Changes in 2.2.0
* Support was added to handle the signing of multi-arch images

## Changes in 2.1.0
* Use the translate-delivery-repo util for translating the reference variable
  * This change comes with a bump in the image used for the task

## Changes in 2.0.0
* The internalrequest CRs are created with a label specifying the pipelinerun uid with the new pipelineRunUid parameter
  * This change comes with a bump in the image used for the task

## Changes in 1.2.0
* Optimize the task to process multiple images in parallel. This will improve the performance of the task.
* Add a new `concurrentLimit` parameter that controls the number of images to be processed in parallel

## Changes in 1.0.1
* Updated hacbs-release/release-utils image to reference redhat-appstudio/release-service-utils image instead

## Changes in 1.0.0
* Translate docker-reference when signing images
  * Before this change, signing request would be sent with the actual quay location of the image. Instead, the reference
    need to be translated to the public facing reference.
    * E.g. quay.io/redhat-prod/rhtas-tech-preview----tuf-server-rhel9:1.0.beta needs to be translated to
      registry.redhat.io/rhtas-tech-preview/tuf-server-rhel9:1.0.beta. Similarly, quay.io/redhat-pending references
      need to be translated to registry.stage.redhat.io.

## Changes in 0.1.0
* Also sign floating tag
  * In addition to pushing $tagPrefix-$timestamp tag, we now also push
    $tagPrefix tag a.k.a. commonTag, so this needs to be signed as well
  * Rename parameter commonTag to commonTags which will contain both tags to sign
