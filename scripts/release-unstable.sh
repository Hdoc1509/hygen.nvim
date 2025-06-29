REPO_ROOT=$(git rev-parse --show-toplevel)
export REPO_ROOT

# shellcheck disable=SC1091
source "$REPO_ROOT"/scripts/utils.sh

# INITIAL RELEASE
if ! [[ -f CHANGELOG.md ]]; then
  echo "[RELEASE]: Initial release!"
  echo -e '[RELEASE]: Breaking changes check will be skipped!\n'

  pnpm changeset version

  # changelog is now generated
  set_changelog_initial_release_message

  exit 0
fi

get_last_tag() { git describe --tags --abbrev=0; }

# NORMAL RELEASE
previous_version=$(get_version_from_changelog)

# changes since last release
unstable_message_regex='^\w+(\(.*\))?:!'
breaking_changes_count=$(
  git log "$(get_last_tag)"..HEAD --oneline |
    grep --count --extended-regexp "$unstable_message_regex"
)

echo -e '[RELEASE]: Unstable version release!\n'

# genrate changelog and update version
pnpm changeset version

# NOTE: uncomment to test
# breaking_changes_count=1

if [[ $breaking_changes_count -gt 0 ]]; then
  set_changelog_breaking_changes_message "patch" "$previous_version"
fi
