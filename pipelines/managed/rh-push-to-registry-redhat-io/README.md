# rh-push-to-registry-redhat-io pipeline

Tekton pipeline to release content to registry.redhat.io registry.

## Parameters

| Name                            | Description                                                                                                                        | Optional | Default value                                             |
|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------|----------|-----------------------------------------------------------|
| release                         | The namespaced name (namespace/name) of the Release custom resource initiating this pipeline execution                             | No       | -                                                         |
| releasePlan                     | The namespaced name (namespace/name) of the releasePlan                                                                            | No       | -                                                         |
| releasePlanAdmission            | The namespaced name (namespace/name) of the releasePlanAdmission                                                                   | No       | -                                                         |
| releaseServiceConfig            | The namespaced name (namespace/name) of the releaseServiceConfig                                                                   | No       | -                                                         |
| snapshot                        | The namespaced name (namespace/name) of the snapshot                                                                               | No       | -                                                         |
| enterpriseContractPolicy        | JSON representation of the policy to be applied when validating the enterprise contract                                            | No       | -                                                         |
| enterpriseContractExtraRuleData | Extra rule data to be merged into the policy specified in params.enterpriseContractPolicy. Use syntax "key1=value1,key2=value2..." | Yes      | pipeline_intention=release                                |
| enterpriseContractTimeout       | Timeout setting for `ec validate`                                                                                                  | Yes      | 90m0s                                                     |
| enterpriseContractWorkerCount   | Number of parallel workers to use for policy evaluation.                                                                           | Yes      | 4                                                         |
| postCleanUp                     | Cleans up workspace after finishing executing the pipeline                                                                         | Yes      | true                                                      |
| verify_ec_task_bundle           | The location of the bundle containing the verify-enterprise-contract task                                                          | No       | -                                                         |
| verify_ec_task_git_revision     | The git revision to be used when consuming the verify-conforma task                                                                | No       | -                                                         |
| taskGitUrl                      | The url to the git repo where the release-service-catalog tasks to be used are stored                                              | Yes      | https://github.com/konflux-ci/release-service-catalog.git |
| taskGitRevision                 | The revision in the taskGitUrl repo to be used                                                                                     | No       | -                                                         |
| ociStorage                      | The OCI repository where the Trusted Artifacts are stored                                                                          | Yes      | quay.io/konflux-ci/release-service-trusted-artifacts      |
| orasOptions                     | oras options to pass to Trusted Artifacts calls                                                                                    | Yes      | ""                                                        |
| trustedArtifactsDebug           | Flag to enable debug logging in trusted artifacts. Set to a non-empty string to enable                                             | Yes      | ""                                                        |
| dataDir                         | The location where data will be stored                                                                                             | Yes      | /var/workdir/release                                      | 

## Changes in 5.0.1
* This pipeline is now using trusted artifacts. Therefore, we can remove the comments and timeouts
  added to workaround PVC contention issues.

## Changes in 5.0.0
* Activate the use of trusted artifacts
* Use the verify-conforma task to verify the enterprise contract policy

## Changes in 4.9.0
* Update all tasks that now support trusted artifacts to specify the taskGit* parameters for the step action resolvers
* Align workspace name with changes in the apply-mapping task

## Changes in 4.8.0
* Add new parameter `verify_ec_task_git_revision` needed for consuming the verify-conforma task
  via git resolver

## Changes in 4.7.2
* Pass taskGitUrl and taskGitRevision to run-file-updates task

## Changes in 4.7.1
* Set timeout for rh-sign-image-cosign task to be 6 hrs

## Changes in 4.7.0
* Update all task pathInRepo values as they are now in `tasks/managed`

## Changes in 4.6.0
* Add the `check-data-keys` task to validate the `data.json` file using the JSON schema.

## Changes in 4.5.6
* new mandatory parameter `dataPath` added to `create-pyxis-image` task

## Changes in 4.5.5
* new mandatory parameter resultsDirPath added to run-file-updates task

## Changes in 4.5.4
* Add retries to apply-mapping task in case of transient errors

## Changes in 4.5.3
* Fix the missing pyxis error on rh-push-to-registry-redhat-io
  * Missing the pyxisServer and pyxisSecret when calling rh-sign-image task.

## Changes in 4.5.2
* Make task order more explicit
  * No functional change, the tasks already depended on the other tasks'
    results, but this makes it more explicit (and Tekton PLR UI
    is known to show incorrect order when relying on task results only)

## Changes in 4.5.1
* Task `publish-pyxis-repository` should only run after `apply-mapping` has completed as it depends on the `repository`
  value

## Changes in 4.5.0
* Only sign `registry.access*` references if required
  * Task `publish-pyxis-repository` has a new `signRegistryAccessPath` result that is passed
    to tasks `rh-sign-image` and `rh-sign-image-cosign`. It points to a file that contains a list of repositories
    for which we also need to sign `registry.access*` references. We will skip those by default.
  * Some task reordering was required for this:
    * We run `rh-sign-image` before `push-snapshot` because it's less reliable. We want to keep this.
    * `publish-pyxis-repository` was run towards the end, but now it needs to run early on,
      because`rh-sign-image` needs its result.

## Changes in 4.4.0
* Increase timeout for rh-sign-image task to be 6 hrs
* Add new mandatory parameter value for releasePlanAdmissionPath for rh-sign-image task
* Add new parameter values for taskGit* parameters.
* Introduce new optional parameter `enterpriseContractWorkerCount` to increase performance of ec verify task

## Changes in 4.3.2
* Add retries for some tasks

## Changes in 4.3.1
* Increase timeout for signing IRs from 20 to 30 min
  * We got reports from users that they repeatedly see timeouts here

## Changes in 4.3.0
* Add new reduce-snapshot task

## Changes in 4.2.0
* The `push-rpm-manifest-to-pyxis` task is renamed to `push-rpm-data-to-pyxis`

## Changes in 4.1.0
* The `publish-pyxis-repository` now gets the `resultsDirPath` parameter from the `collect-data` results

## Changes in 4.0.1
* Increase `rh-sign-image` timeout from 600s to 1200s as we have seen reports
  of it timing out while waiting for internalRequests to complete.

## Changes in 4.0.0
* Drop the `enterpriseContractPublicKey` param. The verify task will take the value from the policy.

## Changes in 3.11.0
* Add `requireInternalServices` parameter to the 'verify-access-to-resources' task.

## Changes in 3.10.2
* Increase `enterpriseContractTimeout` parameter default value.

## Changes in 3.10.1
* Add `enterpriseContractTimeout` parameter.

## Changes in 3.10.0
* Add tasks `collect-cosign-params` and `rh-sign-image-cosign` to sign images by cosign. `rh-sign-image-cosign` is only run if sign.cosignSecretName is set in the data file.

## Changes in 3.9.0
* Removed `verify-access-to-resources` script and replaced it with a task.

## Changes in 3.8.0
* The `rh-sign-image` task no longer receives the `commonTags` parameter
* The `create-pyxis-image` task no longer receives the `commonTags` nor `dataPath` parameter

## Changes in 3.7.0
* The `push-snapshot` task now gets the `resultsDirPath` parameter from `collect-data` results

## Changes in 3.6.0
* Add the task `update-cr-status` at the end of the pipeline to save all pipeline results

## Changes in 3.5.1
* The when conditions that skipped tasks if the `push-snapshot` result `commonTags` was empty was removed
  * This is due to the migration to the new tag format. A similar when will be readded with RELEASE-932

## Changes in 3.5.0
* The apply-mapping task now gets the dataPath parameter instead of releasePlanAdmissionPath

## Changes in 3.4.0
* `enterpriseContractExtraRuleData` added as a pipeline parameter, which is
  then passed to EC. Allows for easier runtime changes to rule data.

## Changes in 3.3.1
* The RADAS timeout when it fails to receive a response is 5 mins.
  We double the requestTimeout in the rh-sign-image task to allow
  RADAS to retry its request.

## Changes in 3.3.0
* Add new task `push-rpm-manifests-to-pyxis` to run after `create-pyxis-image`

## Changes in 3.2.0
* Update the taskGitUrl default value due to migration
  to konflux-ci GitHub org

## Changes in 3.1.2
* Added `when` clause to `push-snapshot` task in the pipeline
  to ensure it only executes when the `apply-mapping` task
  indicates that mapping was successful.

## Changes in 3.1.1
* Added a `when` clause to the following tasks
  `rh-sign-image`,
  `create-pyxis-image`
  `collect-pyxis-params` and
  `run-file-updates`
  to ensure they only execute when the `push-snapshot`
  task result indicates that `commonTags` is not an empty string

## Changes in 3.1.0
* Remove push-sbom-to-pyxis. It has been replaced by manifest-box.

## Changes in 3.0.0
* releaseServiceConfig added as a pipeline parameter that is passed to the collect-data task

## Changes in 2.0.0
* Parameters supplied by the Release Service operator now use camelCase format

## Changes in 1.9.0
* Modified the pipeline to dynamically source the `data.json`, `snapshot_spec.json` and
  `release_plan_admission.json` files from the results of the `collect-data` task.

## Changes in 1.8.1
* Tasks that interact with InternalRequests now have a pipelineRunUid parameter added to them to help with cleanup

## Changes in 1.8.0
* taskGitRevision no longer has a default. It will be provided by the operator and will always have the same value as
  the git revision in the PipelineRef definition of the PipelineRun if using a git resolver. See RHTAPREL-790 for details

## Changes in 1.7.0
* taskGitUrl parameter is added. It is used to provide the git repo for the release-service-catalog tasks
* taskGitRevision parameter is added. It is used to provide the revision to be used in the taskGitUrl repo

## Changes in 1.6.0
* The publish-pyxis-repository task now has a dataPath parameter. It is used to set
  source_container_image_enabled if `pushSourceContainer` is present in the data `images` key
  and set to true

## Changes in 1.4.2
* Move from commonTag to commonTags
  * The result of push-snapshot was renamed to commonTags and now it contains both the fixed and floating
    tags, e.g. tagprefix-timestamp and tagprefix. The consuming tasks (rh-sign-image and create-pyxis-image)
    were also modified to take advantage of this

## Changes in 1.4.0
* The parameter `pushSourceContainer` in the `push-snapshot` task
  was not added correctly in the previous version, the new version
  fixes the issue.

## Changes in 1.3.0
* add parameter `pushSourceContainer` to `push-snapshot`, this will
  enable push of the source container image and fail the pipeline if the
  image is not available.

## Changes in 1.2.0
* Set rhPush and commonTag when calling create-pyxis-image task
* Add publish-pyxis-repository task

## Changes in 1.1.1
* Add tasks extract-requester-from-release and rh-sign-image so the pipeline can sign
  component images using the requester username

## Changes in 1.1.0
* Pass path to ReleasePlanAdmission to the apply-mapping task

## Changes in 1.0.0
* Switch back to using bundle resolvers for the verify-enterprise-contract task

## Changes in 0.1.0
* Removed tagPrefix, timestampFormat, tag, addGitShaTag, addSourceShaTag, addTimestampTag parameters
  * These are now provided in the data json that is collected in the collect-data task
