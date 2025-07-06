changelog_file=$REPO_ROOT/CHANGELOG.md
breaking_changes_message_file=$REPO_ROOT/scripts/breaking-change-message.md

trigger_release() {
  if ! pnpm changeset version; then
    echo
    echo "[RELEASE]: Error while generating changelog!"
    exit 1
  fi
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

  sed -i "4r $breaking_changes_message_file" "$changelog_file"
  sed -i "s/{{ compatible_semver }}/$compatible_semver/" "$changelog_file"
  sed -i "s/{{ version_lazy }}/$version_lazy/" "$changelog_file"
  sed -i "s/{{ version_packer }}/$version_packer/" "$changelog_file"

  echo "[RELEASE]: Breaking changes message generated!"
}

reminder_message() {
  echo
  echo "[RELEASE]: Release reminder!"
  echo "[RELEASE]: If all changes are correct, update lock file by running:"
  # inject:bash:
  echo "> pnpm install"
  echo
  echo "[RELEASE]: Don't forget to commit the changes!"
  echo "[RELEASE]: Don't forget to generate git tags:"
  # inject:bash:
  echo "> npx changeset tag"
}
