# push-oot-kmods pipeline 

Tekton pipeline to sign and push out-of-tree kernel modules with internal signing server.

## Parameters
| Name                            | Description                                                                                                                        	       | Optional | Default value                                             |
|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------|----------|-----------------------------------------------------------|
| release                         | The namespaced name (namespace/name) of the Release custom resource initiating this pipeline execution                                     | No       | -                                                         |
| releasePlan                     | The namespaced name (namespace/name) of the releasePlan                                                                                    | No       | -                                                         |
| releasePlanAdmission            | The namespaced name (namespace/name) of the releasePlanAdmission                                                                           | No       | -                                                         |
| releaseServiceConfig            | The namespaced name (namespace/name) of the releaseServiceConfig                                                                           | No       | -                                                         |
| snapshot                        | The namespaced name (namespace/name) of the snapshot                                                                                       | No       | -                                                         |
| enterpriseContractPolicy        | JSON representation of the EnterpriseContractPolicy                                                                                        | No       | -                                                         |
| enterpriseContractExtraRuleData | Extra rule data to be merged into the policy specified in params.enterpriseContractPolicy. Use syntax "key1=value1,key2=value2..."         | Yes      | pipeline_intention=release                                |
| enterpriseContractTimeout       | Timeout setting for `ec validate`                                                                                                          | Yes      | 40m0s                                                     |
| enterpriseContractWorkerCount   | Number of parallel workers to use for policy evaluation.                                                                                   | Yes      | 4                                                         |
| verify_ec_task_bundle           | The location of the bundle containing the verify-enterprise-contract task                                                                  | No       | -                                                         |
| verify_ec_task_git_revision     | The git revision to be used when consuming the verify-conforma task                                                                        | No       | -                                                         |
| postCleanUp                     | Cleans up workspace after finishing executing the pipeline                                                                                 | Yes      | true                                                      |
| taskGitUrl                      | The url to the git repo where the release-service-catalog tasks to be used are stored                                                      | Yes      | https://github.com/konflux-ci/release-service-catalog.git |
| taskGitRevision                 | The revision in the taskGitUrl repo to be used                                                                                             | No       | -                                                         |
