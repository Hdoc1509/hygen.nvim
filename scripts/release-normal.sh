release_normal() {
  local previous_version=$1
  local changelog_file=$2
  local breaking_changes_count

  echo -e "[RELEASE]: Normal release!\n"

  trigger_release

  breaking_changes_count=$(
    sed --quiet '5p' "$changelog_file" | grep --count "Major"
  )

  # NOTE: uncomment to test
  # breaking_changes_count=1

  if [[ $breaking_changes_count -gt 0 ]]; then
    add_breaking_changes_message "minor" "$previous_version" "$changelog_file"
  fi

  reminder_message
}
