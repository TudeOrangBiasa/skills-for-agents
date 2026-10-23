# Releasing

User-facing changes (`skills/`, top-level `README.md`) each bring a changeset file under `.changeset/` describing the change in one paragraph (`minor` for features, `patch` for fixes). `CHANGELOG.md` is generated from them by `npm run version`, never hand-edited; version bumps ride the same command. No release leaves pending changesets behind.

This repo is public: every merged batch of user-facing changes ships as a versioned GitHub Release (merge to main, tag the version, publish release notes from the changelog). Main never sits on unreleased user-facing changes; cut the release when the batch lands.

Versioning follows semver. Patch (0.0.x): fixes with no behavior change (typos, wording, internal bugfixes). Minor (0.x.0): new skills, playbooks, triggers, policy changes. Major (1.0.0 and up): renames, deletions, invocation changes, anything breaking existing installs. Pre-1.0 breaking changes ride minors. The 1.0.0 bar: vibe-tested skills, a working npm flow, no pending renames or deletions.
