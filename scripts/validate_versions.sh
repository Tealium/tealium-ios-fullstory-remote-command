#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."

get_version() {
  local constants='' regex='' versionConstant=''
  local podspecFile='' podspecRegex='' podspecVersion=''

  constants=$(<"${REPO_ROOT}/Sources/FullstoryConstants.swift")
  regex='^.*static let version = "([0-9\.]*)"'

  if [[ $constants =~ $regex ]]; then
    versionConstant=${BASH_REMATCH[1]}
  else
    echo "Couldn't match the library version, exiting" >&2
    return 1
  fi

  podspecFile=$(<"${REPO_ROOT}/TealiumFullstory.podspec")
  podspecRegex='^.*s\.version[[:space:]]*= "([0-9\.]*)"'

  if [[ $podspecFile =~ $podspecRegex ]]; then
    podspecVersion=${BASH_REMATCH[1]}
  else
    echo "Couldn't match the podspec version, exiting" >&2
    return 1
  fi

  if [[ "$podspecVersion" != "$versionConstant" ]]; then
    echo -e "The podspec version \"$podspecVersion\" is different from the version constant \"$versionConstant\".\nDid you forget to update one of the two?" >&2
    return 1
  fi

  echo "$versionConstant"
}

# If executed directly: just validate & print
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  version="$(get_version)"
  echo "Success: all versions match: $version"
fi
