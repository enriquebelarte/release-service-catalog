#!/usr/bin/env bash
set -eux

# mocks to be injected into task step scripts

function cosign() {
  echo Mock cosign called with: $*
  echo $* >> $(workspaces.data.path)/mock_cosign.txt

  # mock cosign failing the first 3x for the retry test
  if [[ "$*" == "copy -f registry.io/retry-image:tag "*":"* ]]
  then
    if [[ $(cat $(workspaces.data.path)/mock_cosign.txt | wc -l) -le 3 ]]
    then
      echo Expected cosign call failure for retry test
      return 1
    fi
  fi

  if [[ "$*" != "copy -f "*":"*" "*":"* ]]
  then
    echo Error: Unexpected call
    exit 1
  fi
}

function skopeo() {
  echo Mock skopeo called with: $* >&2
  echo $* >> $(workspaces.data.path)/mock_skopeo.txt

  if [[ "$*" == "inspect --override-arch "*" --no-tags --format {{.Digest}} docker://"* ]]; then
    # test scenarios where we want to skip the push because the image already exists
    if [[ "$7" == *skip-image*.src || "$7" == *skip-image*-source ]]; then
      echo "sha256:000000"
    elif [[ "$7" == *skip-image* ]]; then
      echo "sha256:111111"
    else
      # echo the shasum computed from the pull spec so the task knows if two images are the same
      echo -n "sha256:"
      echo $7 | sha256sum | cut -d ' ' -f 1
    fi
    return
  fi
  if [[ "$*" == "inspect --override-arch "*" --no-tags docker://"* ]]; then
    return
  fi

  # If neither of the above matched, it's an unexpected call
  echo Error: Unexpected call
  exit 1
}

function date() {
  echo $* >> $(workspaces.data.path)/mock_date.txt

  case "$*" in
      "+%Y-%m-%dT%H:%M:%SZ")
          echo "2023-10-10T15:00:00Z" |tee $(workspaces.data.path)/mock_date_iso_format.txt
          ;;
      "+%s")
          echo "1696946200" | tee $(workspaces.data.path)/mock_date_epoch.txt
          ;;
      "*")
          echo Error: Unexpected call
          exit 1
          ;;
  esac
}

function get-image-architectures() {
    echo '{"platform":{"architecture": "amd64", "os": "linux"}, "digest": "abcdefg"}'
    echo '{"platform":{"architecture": "ppc64le", "os": "linux"}, "digest": "deadbeef"}'
}
