#!/bin/bash

# Per-package test runner invoked from `melos run test:changes`.
#
# Why this exists: in `melos exec`, `--include-dependents` runs AFTER all
# package filters (see `applyFilters` in melos's package.dart). When a change
# affects e.g. `stream_chat`, melos pulls in every transitive dependent from
# the unfiltered workspace — including `*_example` packages that have no
# `test/` directory and `sample_app/` which we don't test in this matrix.
# Filtering via `dirExists: test` or `--ignore="*example*"` doesn't help
# because those filters are bypassed for dependents.
#
# So the skip decision happens here, after melos has computed the affected
# set. `set -e` plus an explicit `exec` ensures real test failures propagate
# (the original inline `[ -d test ] && X || Y` workaround silently swallowed
# failures when `flutter test` exited non-zero).

set -e

if [[ "$MELOS_PACKAGE_NAME" == *_example ]]; then
  echo "→ Skipping example: $MELOS_PACKAGE_NAME"
  exit 0
fi

if [ ! -d test ]; then
  echo "→ No test/ in $MELOS_PACKAGE_NAME, skipping"
  exit 0
fi

exec flutter test --no-pub --coverage
