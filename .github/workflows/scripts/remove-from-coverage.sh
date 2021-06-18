#!/bin/bash

# Fast fail the script on failures.
set -e

pub global activate remove_from_coverage --overwrite
pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '\.g\.dart$' -r '\.freezed\.dart$'