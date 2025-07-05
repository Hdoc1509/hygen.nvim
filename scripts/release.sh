REPO_ROOT=$(git rev-parse --show-toplevel)
export REPO_ROOT

# shellcheck disable=SC1091
source "$REPO_ROOT"/scripts/utils.sh

previous_version=$(get_current_version)

pnpm changeset version

major_change_count=$(sed --quiet '5p' "$REPO_ROOT"/CHANGELOG.md | grep --count "Major")

# NOTE: uncomment to test
# major_change_count=1

if [[ $major_change_count -gt 0 ]]; then
  add_breaking_changes_message "minor" "$previous_version"
fi
