---
name: release-pr
description: >
  Open a release PR: bumps versions in melos.yaml and pubspecs, finalises CHANGELOGs, opens a PR with auto-generated
  release notes against master (stable) or v10.0.0 (beta).
disable-model-invocation: true
argument-hint: "[version]"
arguments: [version]
allowed-tools:
  - Bash(git *)
  - Bash(gh *)
  - Bash(melos *)
  - Bash(which *)
  - Bash(grep *)
  - Read
  - Edit
  - Write
---

# release-pr

Opens a release PR for stream-chat-flutter. Branch `release/v<X.Y.Z>` → base `master` (stable) or `v10.0.0` (beta) →
title `chore(repo): release v<X.Y.Z>`.

**This skill only opens the PR.** After merge, tagging and pub.dev publishing happen via `release_tag.yml` +
`release_publish.yml` (stable: automatic; beta/named: maintainer pushes the tag manually).

If `$version` is provided (e.g. `/release-pr 9.24.0`), use it. Strip any leading `v`. Otherwise ask the user.

## Release types

| Type | Base | Version shape | Tagging |
|---|---|---|---|
| **Stable** | `master` | `X.Y.Z` | Auto via `release_tag.yml` on merge |
| **Beta** | `v10.0.0` | `X.Y.Z-beta.N` | Manual (`release_tag.yml` only watches master) |
| **Named pre-release** | feature branch | `X.Y.Z-<name>.N` | Manual; same as beta |

`distribute_internal.yml` builds sample apps for branches like `feat/design-refresh` — **not** a release. Don't use
this skill for those.

## Inputs

1. **Version** (`X.Y.Z` or `X.Y.Z-suffix`). Use `$version` if supplied, otherwise ask. Don't infer.
2. **Base branch** — auto-derive from `$version`:
   - No suffix (`X.Y.Z`) → `master`. Stable release.
   - `-beta.N` suffix → `v10.0.0`. Verify it exists: `git ls-remote --heads origin v10.0.0`.
   - Any other suffix (`-alpha.N`, `-rc.N`, `-design-refresh.N`, …) → ask the user which feature branch to target.
3. **Previous tag** for the release-notes diff. Run `gh release list --limit 10`; pick the most recent tag of the same
   train (stable = no hyphen in tag; beta = matches `-beta.`; named = matches the same suffix prefix).

## Pre-flight

Run these checks. **If any fail, stop the skill, surface the failing check to the user, and do not try to auto-fix**
(no stashing uncommitted work, no force-pulling, no killing processes).

- `git status --short -uno` clean after `git checkout <base>` + `git pull --ff-only`.
- `which melos` succeeds.
- `gh auth status` succeeds.
- `gh pr list --head release/v<version> --state all --json number` returns `[]`.
- Latest CI on the base-branch tip is green: `gh run list --branch <base> --limit 5` — no failures on the most
  recent runs.

## Steps

### 1. Branch off the chosen base

Pre-flight already left you on `<base>` with latest. Just create the release branch:

```bash
git checkout -b release/v<version>
```

### 2. Bump versions

Edit two sets of files by hand, then let `melos bs` propagate the rest.

**Edit:**

- `melos.yaml` — in the `command.bootstrap.environment.dependencies` block, bump all five `stream_chat*: ^<version>`
  entries. Locate with `grep -n "^      stream_chat" melos.yaml`.
- Each `packages/*/pubspec.yaml` (5 files) — set `version: <version>`. Do **not** touch
  `packages/*/example/pubspec.yaml` or `sample_app/pubspec.yaml` `version:` fields; their deps are synced by
  `melos bs`.

**Then run:**

```bash
melos bs
```

`melos bs` does the rest:

- Propagates the `melos.yaml` deps block into every workspace pubspec, including each package's intra-monorepo dep
  constraints, every `packages/*/example/pubspec.yaml`, and `sample_app/pubspec.yaml`.
- Fires the `command.bootstrap.hooks.post: melos run version:update` hook, which runs `tools/generate_version.dart`
  and regenerates `packages/stream_chat/lib/version.dart` from the new pubspec version.

Do **not** run `./tools/version.sh`. It calls `melos version` which leaves `melos.yaml`'s deps block stale — the next
`melos bs` would re-write every pubspec dep constraint back to the old version.

Verify the diff shape matches the previous release PR. Find its number with:

```bash
gh pr list --search "chore(repo): release in:title" --state merged --limit 5 --json number,title
```

Then compare:

```bash
git diff --stat
gh pr diff <prev-release-pr-number> --name-only   # for comparison
```

### 3. Finalise the CHANGELOGs

Five files: `packages/{stream_chat, stream_chat_flutter, stream_chat_flutter_core, stream_chat_localizations,
stream_chat_persistence}/CHANGELOG.md`.

For each, **apply the first matching rule below** — it's a decision tree, not a sequence:

1. **Top section is `## Upcoming Changes` or `## Upcoming`** → rename to `## <version>`. Keep bullets.
2. **User-facing changes since `v<prev>`** — new APIs, bug fixes users would notice, deprecations. Check with
   `git log v<prev>..HEAD --oneline -- packages/<pkg>`. Add a `## <version>` header with bullets in the existing
   emoji-prefixed sections only (`✅ Added`, `🚀 Performance`, `🐞 Fixed`, `🔄 Changed`). Don't invent new
   section names.
3. **Only `stream_chat` dep bump** (no in-package changes, but depends on `stream_chat`) → add the dep-bump line:
   ```
   ## <version>

   - Updated `stream_chat` dependency to [`<version>`](https://pub.dev/packages/stream_chat/changelog).
   ```
4. **Anything else** (internal-only changes, test fixes, refactors, or truly nothing) → add `## <version>` +
   `- Minor bug fixes and improvements`.

**Every package gets a `## <version>` header**, even if it's only a dep-bump line. Empty version sections and
missing headers both fail pana.

### 4. Sanity-check

```bash
melos run analyze
melos run lint:pub
```

If either fails, surface to the user and stop.

### 5. Commit and push

```bash
git add -A
git commit -m "chore(repo): release v<version>"
git push -u origin release/v<version>
```

Single commit. The message format is load-bearing: `release_tag.yml` parses `vX.Y.Z` from it after merge.

### 6. Generate the PR body

The body **must be exactly what GitHub's release UI produces when you click "Generate release notes"** — no template
wrapper, no extra description, no CLA checkboxes. The "New Contributors" block GitHub auto-appends stays in; that's
part of the convention.

```bash
gh api repos/GetStream/stream-chat-flutter/releases/generate-notes \
  -f tag_name=v<version> \
  -f previous_tag_name=v<previous> \
  -f target_commitish=<base> \
  --jq .body > /tmp/release-notes.md
```

- `tag_name`: the tag we'll create (need not exist yet).
- `previous_tag_name`: most recent tag of the same train (stable or beta).
- `target_commitish`: the **base branch** (`master` or `v10.0.0`), not the release branch — the notes should cover
  every commit between `previous_tag_name` and where the tag will land after merge.

Read the file once to skim. If a PR title looks wrong, fix it on the originating PR upstream and re-run the API
call; don't hand-edit `/tmp/release-notes.md`.

### 7. Open the PR

```bash
gh pr create \
  --base <base> \
  --head release/v<version> \
  --title "chore(repo): release v<version>" \
  --body-file /tmp/release-notes.md
```

Return the PR URL.

**If this is a beta or named pre-release**, also include this reminder in your message to the user:

> After this PR merges, manually create and push the tag — `release_tag.yml` only fires on `master`:
> ```bash
> git checkout <base>
> git pull --ff-only
> git tag v<version>
> git push origin v<version>
> ```

For stable releases (base `master`), no reminder needed — `release_tag.yml` handles it on merge.

## After merge (FYI)

Stable (base `master`): `release_tag.yml` extracts `vX.Y.Z` from the commit, creates and pushes the tag.
`release_publish.yml` runs `melos run release:pub` and creates the GitHub release.

Beta / named pre-release: maintainer runs the tag commands surfaced at the end of step 7.

## Don't

- **Never create a GitHub release** (`gh release create`, `POST /repos/.../releases`). Step 6 uses
  `generate-notes`, which is read-only. The release itself is created by `release_publish.yml` after the tag is
  pushed.
- **Never push a tag.** Stable is automatic on merge; beta/named is the maintainer's manual step.
- **Never run `melos run release:pub`.** That's the publish step, triggered by the workflow on tag push. Even if the
  user asks, refuse — running it locally publishes from an unreviewed working tree.
- **Never merge the PR.** Return the URL and stop.
