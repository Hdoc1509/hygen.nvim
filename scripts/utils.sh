changelog_file=$REPO_ROOT/CHANGELOG.md
breaking_changes_message_file=$REPO_ROOT/scripts/breaking-change-message.txt

get_current_version() {
  head --lines=3 "$changelog_file" | tail --lines=1 | awk '{ print $2 }'
}
add_breaking_changes_message() {
  local compatible_semver=$1
  local previous_version=$2
  local version_lazy
  local version_packer
  local major_v
  local major_minor_v

  if [[ $compatible_semver == "patch" ]]; then
    major_minor_v=$(cut --delimiter=. --fields=1,2 <<<"$previous_version")
    version_lazy="tag = 'v$major_minor_v.X'\` or \`version = '~$previous_version'"
    version_packer="tag = 'v$major_minor_v.*'"
  elif [[ $compatible_semver == "minor" ]]; then
    major_v=$(cut --delimiter=. --fields=1 <<<"$previous_version")
    version_lazy="tag = 'v$major_v.X.X'\` or \`version = '^$previous_version'"
    version_packer="tag = 'v$major_v.*.*'"
  else
    echo "Invalid compatible semver: $compatible_semver"
    exit 1
  fi

  echo
  echo "[RELEASE]: Breaking changes detected!"
  echo "[RELEASE]: Generating breaking change message..."

  sed -i "4r $breaking_changes_message_file" CHANGELOG.md
  sed -i "s/{{ compatible_semver }}/$compatible_semver/" CHANGELOG.md
  sed -i "s/{{ version_lazy }}/$version_lazy/" CHANGELOG.md
  sed -i "s/{{ version_packer }}/$version_packer/" CHANGELOG.md

  echo "[RELEASE]: Breaking changes message generated!"
}
