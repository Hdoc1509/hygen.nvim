// @ts-check

// same as @changesets/changelog-git but with commit links in the changelog
// https://github.com/changesets/changesets/blob/main/packages/changelog-git/src/index.ts

/** @typedef {import('@changesets/types').ChangelogFunctions} ChangelogFunctions */

const GH_BASE_URL = "https://github.com";

/**
 * @param {string} commit
 * @param {string} repo
 */
const createCommitLink = (commit, repo) =>
  `[${commit.slice(0, 7)}](${GH_BASE_URL}/${repo}/commit/${commit})`;

/** @type {ChangelogFunctions["getReleaseLine"]} */
const getReleaseLine = async (changeset, _type, options) => {
  if (options?.repo == null)
    throw new Error(
      "Please provide a `repo` option to this changelog generator, like this:\n" +
        '"changelog": ["./with-links-changelog.cjs", { "repo": "user/repo" }]'
    );

  const [firstLine, ...futureLines] = changeset.summary
    .split("\n")
    .map((l) => l.trimEnd());

  let returnVal = `- ${
    changeset.commit
      ? `${createCommitLink(changeset.commit, options.repo)}: `
      : ""
  }${firstLine}`;

  if (futureLines.length > 0) {
    returnVal += `\n${futureLines.map((l) => `  ${l}`).join("\n")}`;
  }

  return returnVal;
};

/** @type {ChangelogFunctions["getDependencyReleaseLine"]} */
const getDependencyReleaseLine = async (
  changesets,
  dependenciesUpdated,
  options
) => {
  if (options?.repo == null)
    throw new Error(
      "Please provide a `repo` option to this changelog generator, like this:\n" +
        '"changelog": ["./with-links-changelog.cjs", { "repo": "user/repo" }]'
    );

  if (dependenciesUpdated.length === 0) return "";

  const changesetLinks = changesets.map(
    (changeset) =>
      `- Updated dependencies${
        changeset.commit
          ? `${createCommitLink(changeset.commit, options.repo)}`
          : ""
      }`
  );

  const updatedDependenciesList = dependenciesUpdated.map(
    (dependency) => `  - ${dependency.name}@${dependency.newVersion}`
  );

  return [...changesetLinks, ...updatedDependenciesList].join("\n");
};

/** @type {ChangelogFunctions} */
const defaultChangelogFunctions = {
  getReleaseLine,
  getDependencyReleaseLine,
};

module.exports = defaultChangelogFunctions;
