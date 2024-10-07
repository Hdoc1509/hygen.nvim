changelog_file=$REPO_ROOT/CHANGELOG.md
breaking_changes_message_file=$REPO_ROOT/docs/breaking-change-message.txt

get_version_from_changelog() {
  head --lines=3 "$changelog_file" | tail --lines=1 | awk '{ print $2 }'
}
set_changelog_initial_release_message() {
  sed -i "5 s/.*/### Initial release/" "$changelog_file"
}
set_changelog_breaking_changes_message() {
  local compatible_semver=$1
  local previous_version=$2
  local previous_version_message
  local breaking_changes_message

  if [[ $compatible_semver == "patch" ]]; then
    previous_version_message="\`~$previous_version\`"
  elif [[ $compatible_semver == "minor" ]]; then
    previous_version_message="\`^$previous_version\` or \`~$previous_version\`"
  else
    echo "Invalid compatible semver: $compatible_semver"
    exit 1
  fi

  breaking_changes_message=$(
    sed \
      -e "s/{{ compatible_semver }}/$compatible_semver/" \
      -e "s/{{ previous_version }}/$previous_version_message/" \
      "$breaking_changes_message_file"
  )

  echo
  echo "[RELEASE]: Breaking changes detected!"
  echo "[RELEASE]: Generating breaking change message..."

  sed -i "4 a$breaking_changes_message\n" CHANGELOG.md

  echo "[RELEASE]: Breaking changes message generated!"
}
