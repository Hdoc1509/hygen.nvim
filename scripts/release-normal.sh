release_normal() {
  local previous_version=$1
  local changelog_file=$2

  echo -e "[RELEASE]: Normal release!\n"

  trigger_release

  breaking_changes_count=$(
    sed --quiet '5p' "$changelog_file" | grep --count "Major"
  )

  # NOTE: uncomment to test
  # breaking_changes_count=1

  if [[ $breaking_changes_count -gt 0 ]]; then
    add_breaking_changes_message "minor" "$previous_version"
  fi

  reminder_message
}
