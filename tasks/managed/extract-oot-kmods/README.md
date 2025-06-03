# extract-oot-kmods

Tekton task that extracts out-of-tree kernel modules from an image.
Paths for .ko files to be signed from image


## Parameters

| Name                | Description                                                                | Optional | Default value |
|---------------------|----------------------------------------------------------------------------|----------|---------------|
| kmodsPath           | Path for the unsigned .ko files to be extracted from the image             | No       | -             |
| signedKmodsPath     | Path to store the extracted file in the workspace                          | No       | -             |
| snapshot            | The namespaced name (namespace/name) of the snapshot                       | No       | -             |
