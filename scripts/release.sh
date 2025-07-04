REPO_ROOT=$(git rev-parse --show-toplevel)
export REPO_ROOT

# shellcheck disable=SC1091
source "$REPO_ROOT"/scripts/utils.sh

previous_version=$(get_version_from_changelog)

# generate changelog and update version
pnpm changeset version

major_change_count=$(head --line=5 CHANGELOG.md | grep --count "Major")

# NOTE: uncomment to test
# major_change_count=1

if [[ $major_change_count -gt 0 ]]; then
  set_changelog_breaking_changes_message "minor" "$previous_version"
fi
