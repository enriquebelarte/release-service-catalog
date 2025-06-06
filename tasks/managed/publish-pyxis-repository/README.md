# publish-pyxis-repository

Tekton task to mark all repositories in the mapped snapshot as published in Pyxis.
This is currently only meant to be used in the rh-push-to-registry-redhat-io
and rh-advisories pipelines,
so it will convert the values to the ones used for registry.redhat.io releases.
E.g. repository "quay.io/redhat-prod/my-product----my-image" will be converted to use
registry "registry.access.redhat.com" and repository "my-product/my-image" to identify
the right Container Registry object in Pyxis. The task also optionally
marks the repositories as source_container_image_enabled true if pushSourceContainer
is true in the data JSON.
Additionally, this task respects the `publish-on-push` flag. If `false`, then the task
does not publish the repository.

The task emits a result: `signRegistryAccessPath`

This contains the relative path in the workspace to a text file that contains a list of repositories
that needs registry.access.redhat.com image references to be signed (i.e.
requires_terms=true), one repository string per line, e.g. "rhtas/cosign-rhel9".

Note: This task runs quite early on in the pipeline, because we need the result it produces
for the signing tasks (and `rh-sign-image` runs quite early to begin with). So this means
that if you're releasing to a repo for the first time, the repository might get published
even before the actual image is pushed and published. But we checked with RHEC team and this
shouldn't cause any problems, because RHEC will ignore repos with no published images.


## Parameters

| Name                    | Description                                                                                                                | Optional  | Default value           |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------|-----------|-------------------------|
| server                  | The server type to use. Options are 'production','production-internal,'stage-internal' and 'stage'.                        | No        | ""                      |
| pyxisSecret             | The kubernetes secret to use to authenticate to Pyxis. It needs to contain two keys: key and cert                          | No        | -                       |
| snapshotPath            | Path to the JSON string of the mapped Snapshot spec in the data workspace                                                  | No        |                         |
| dataPath                | Path to the JSON string of the merged data to use in the data workspace                                                    | No        |                         |
| resultsDirPath          | Path to the results directory in the data workspace                                                                        | No        |                         |
| ociStorage              | The OCI repository where the Trusted Artifacts are stored                                                                  | Yes       | empty                   |
| ociArtifactExpiresAfter | Expiration date for the trusted artifacts created in the OCI repository. An empty string means the artifacts do not expire | Yes       | 1d                      |
| trustedArtifactsDebug   | Flag to enable debug logging in trusted artifacts. Set to a non-empty string to enable                                     | Yes       | ""                      |
| orasOptions             | oras options to pass to Trusted Artifacts calls                                                                            | Yes       | ""                      | 
| sourceDataArtifact      | Location of trusted artifacts to be used to populate data directory                                                        | Yes       | ""                      |
| dataDir                 | The location where data will be stored                                                                                     | Yes       | $(workspaces.data.path) |
| taskGitUrl              | The url to the git repo where the release-service-catalog tasks and stepactions to be used are stored                      | No        | ""                      |
| taskGitRevision         | The revision in the taskGitUrl repo to be used                                                                             | No        | ""                      |

## Changes in 4.0.0
* This task now supports Trusted artifacts

## Changes in 3.0.1
* Fix shellcheck/checkton linting issues in the task and tests

## Changes in 3.0.0
* data json is now mandatory - technically, for some use cases the file is not needed, but requiring it always
  makes it consistent with other tasks and it also makes the task script more readable
* A new `signRegistryAccessPath` result is emitted
  * This contains the relative path in the workspace to a text file that contains a list of repositories
    that needs registry.access.redhat.com image references to be signed (i.e.
    requires_terms=true), one repository string per line, e.g. "rhtas/cosign-rhel9".


## Changes in 2.0.0
* Added JSON results output for published repositories, contains Catalog (RHEC) URL
* Introduced a new `resultsDirPath` parameter to specify the path to the results directory

## Changes in 1.1.0
* Updated the base image used in this task

## Changes in 1.0.0
* `images.pushSourceContainer` is no longer supported

## Changes in 0.6.0
* Updated the base image used in this task

## Changes in 0.5.0
* Add support for checking the `mapping` key for `pushSourceContainer`
  * Can be per component or in the `mapping.defaults` section
  * The legacy location of `images.pushSourceContainer` will be removed in a future version

## Changes in 0.4.0
* Add option to skip publishing via `skipRepoPublishing` flag in the data file

## Changes in 0.3.0
* Remove `dataPath` and `snapshotPath` default values

## Changes in 0.2.2
* Add support for server types of production-internal and stage-internal

## Changes in 0.2.1
* The task now respects the `publish-on-push` flag. If `false`, then the task
does not publish the repository.

## Changes in 0.2.0
* If a data JSON is provided and images.pushSourceContainer is set to true inside it, a call is made
to mark the repository as source_container_image_enabled true

## Changes in 0.0.2
* Updated hacbs-release/release-utils image to reference redhat-appstudio/release-service-utils image instead

## Changes in 0.0.1
* Minor change to logging to provide more context about the pyxis repo request on failure
