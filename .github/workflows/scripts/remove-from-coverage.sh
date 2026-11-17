#!/bin/bash

# Fast fail the script on failures.
set -e

dart run remove_from_coverage@2.0.0 -f coverage/lcov.info -r '\.g\.dart$' -r '\.freezed\.dart$'
