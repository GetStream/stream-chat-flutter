#!/bin/bash

# Fast fail the script on failures.
set -e

flutter pub global run remove_from_coverage:remove_from_coverage -f coverage/lcov.info -r '\.g\.dart$' -r '\.freezed\.dart$'
