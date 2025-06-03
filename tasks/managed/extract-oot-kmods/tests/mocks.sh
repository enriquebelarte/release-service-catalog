#!/usr/bin/env bash
set -eux
 # Mock `get-resource` for testing
get-resource() {
   echo '{
     "metadata": {
       "annotations": {
         "build.appstudio.redhat.com/commit_sha": "mocksha123"
       }
     },
     "spec": {
       "components": [
         {
           "containerImage": "quay.io/mock/image@sha256:dummy"
         }
       ]
     }
   }'
}
skopeo() {
  echo "Mock skopeo called with: $*"
  echo "$*" >> $(workspaces.input-data.path)/mock_skopeo.txt

  case "$*" in
    "copy docker://quay.io/mock/image@sha256:dummy dir:"* | "copy docker://quay.io/mock/image:mocksha123 dir:"*)
      # Extract .ko files into the destination directory
      cp $(workspaces.input-data.path)/kmods/* $TMP_DIR/
      cp $(workspaces.input-data.path)/manifest.json $TMP_DIR/
      ;;
    *)
      echo "Error: Unexpected call"
      exit 1
      ;;
  esac
}
