REPO_ROOT=$(git rev-parse --show-toplevel)
CHANGELOG_FILE=$REPO_ROOT/CHANGELOG.md

source "$REPO_ROOT"/scripts/logger.sh
source "$REPO_ROOT"/scripts/utils.sh

if ! [[ -f $CHANGELOG_FILE ]]; then
  echo "[RELEASE]: Initial release!"
  echo -e '[RELEASE]: Breaking changes check will be skipped!\n'

  trigger_release

  sed -i "5 s/.*/### Initial release/" "$CHANGELOG_FILE"

  exit 0
fi

previous_version=$(sed --quiet '3p' "$CHANGELOG_FILE" | awk '{ print $2 }')

if [[ ${previous_version:0:1} -eq 0 ]]; then
  source "$REPO_ROOT"/scripts/release-major-0.sh
  release_major_0 "$previous_version"
else
  source "$REPO_ROOT"/scripts/release-normal.sh
  release_normal "$previous_version"
fi
