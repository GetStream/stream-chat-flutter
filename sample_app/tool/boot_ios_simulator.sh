#!/usr/bin/env bash
set -euo pipefail

DEVICE_NAME="${1:?usage: boot_ios_simulator.sh <device-name> [ios-version]}"
IOS_VERSION="${2:-${IOS_SIMULATOR_VERSION:-}}"

if [[ -z "${GITHUB_ENV:-}" ]]; then
  echo "GITHUB_ENV must be set (CI step env)" >&2
  exit 1
fi

xcrun simctl shutdown all 2>/dev/null || true

device_id="$(
  xcrun simctl list devices available --json | python3 -c '
import json
import sys

target, ios_version = sys.argv[1], sys.argv[2]
data = json.load(sys.stdin)

if ios_version:
    runtime_slug = "iOS-" + ios_version.replace(".", "-")
    for runtime, devices in data["devices"].items():
        if runtime_slug not in runtime:
            continue
        for device in devices:
            if device["name"] == target and device.get("isAvailable", True):
                print(device["udid"])
                sys.exit(0)
else:
    for runtime, devices in data["devices"].items():
        if not runtime.startswith("com.apple.CoreSimulator.SimRuntime.iOS-"):
            continue
        for device in devices:
            if device["name"] == target and device.get("isAvailable", True):
                print(device["udid"])
                sys.exit(0)

matches = []
for runtime, devices in data["devices"].items():
    if not runtime.startswith("com.apple.CoreSimulator.SimRuntime.iOS-"):
        continue
    for device in devices:
        if device.get("isAvailable", True):
            name = device["name"]
            os_tag = runtime.split("iOS-")[-1]
            matches.append(f"{name} ({os_tag})")

hint = "\n".join(sorted(matches)[:20]) if matches else "(none)"
version_hint = f" on iOS {ios_version}" if ios_version else ""
raise SystemExit(
    f"No available simulator {target!r}{version_hint}\n"
    f"Available iOS simulators:\n{hint}"
)
' "$DEVICE_NAME" "$IOS_VERSION"
)"

echo "device_id=${device_id}" >>"$GITHUB_ENV"
xcrun simctl boot "${device_id}" 2>/dev/null || true
xcrun simctl bootstatus "${device_id}" -b

sleep 10

if [[ -n "$IOS_VERSION" ]]; then
  echo "Booted ${DEVICE_NAME} (${device_id}) on iOS ${IOS_VERSION}"
else
  echo "Booted ${DEVICE_NAME} (${device_id})"
fi
