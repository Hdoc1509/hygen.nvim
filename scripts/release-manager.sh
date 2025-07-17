REPO_ROOT=$(git rev-parse --show-toplevel)
changelog_file=$REPO_ROOT/CHANGELOG.md

# TODO: update release scripts as in tree-sitter-hygen-template

export REPO_ROOT

source "$REPO_ROOT"/scripts/utils.sh

if ! [[ -f $changelog_file ]]; then
  echo "[RELEASE]: Initial release!"
  echo -e '[RELEASE]: Breaking changes check will be skipped!\n'

  trigger_release

  sed -i "5 s/.*/### Initial release/" "$changelog_file"

  exit 0
fi

previous_version=$(sed --quiet '3p' "$changelog_file" | awk '{ print $2 }')
previous_major=$(cut --delimiter=. --fields=1 <<<"$previous_version")

if [[ $previous_major -eq 0 ]]; then
  source "$REPO_ROOT"/scripts/release-major-0.sh
  release_major_0 "$previous_version" "$changelog_file"
else
  source "$REPO_ROOT"/scripts/release-normal.sh
  release_normal "$previous_version" "$changelog_file"
fi
