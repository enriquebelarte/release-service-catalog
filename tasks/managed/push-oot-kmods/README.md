# push-oot-kmods

Tekton task to push signed out-of-tree kernel modules to a private GitLab repository. 

## Parameters

| Name              | Description                                                          | Optional | Default value |
|-------------------|----------------------------------------------------------------------|----------|---------------|
| signedKmodsPath   | Path where the signed kernel modules are stored in the workspace     | No       | -             |
| vendor            | Name of the vendor of the kernel modules                             | No       | -             |
| artifactRepoUrl   | Repository URL where the signed modules will be pushed               | No       | -             |
| artifactBranch    | Specific branch in the repository                                    | Yes      | "main"        |
| artifactRepoToken | Secret containing the Project Access Token for the artifact repos    | No       | -             |
