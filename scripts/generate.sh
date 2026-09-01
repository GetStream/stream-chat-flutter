#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Usage:
#   CHAT_BACKEND_DIR=/absolute/path/to/chat melos run gen:openapi
#   (or) export CHAT_BACKEND_DIR=... then: melos run gen:openapi
#
# CHAT_BACKEND_DIR points at a checkout of the backend monolith
# (GetStream/chat), which hosts the OpenAPI spec + code generator.
#
# Optionally, PROTOCOL_DIR points at a checkout of the protocol repo
# (GetStream/protocol), which publishes the released specs shared by every
# Stream SDK. When set, that spec is used as-is instead of generating a fresh
# one, which pins generation to a released API version and saves a minute.
#
#   PROTOCOL_DIR=/path/to/protocol CHAT_BACKEND_DIR=/path/to/chat melos run gen:openapi
#
# CHAT_BACKEND_DIR is required either way: the client generator lives in the
# backend monolith, and protocol ships specs only.
#
# Requires: go, dart
# Melos sets MELOS_ROOT_PATH when invoked via `melos run`
# ============================================================

# ---------- config (env-required) ----------
: "${CHAT_BACKEND_DIR:?❌ CHAT_BACKEND_DIR not set.
Please run with:
  CHAT_BACKEND_DIR=/path/to/chat melos run gen:openapi
or export it in your shell/profile.}"

# ---------- config (env-optional) ----------
PROTOCOL_DIR="${PROTOCOL_DIR:-}"

# ---------- paths ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${MELOS_ROOT_PATH:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

PKG_DIR="${REPO_ROOT}/packages/stream_chat"
OUTPUT_DIR="${PKG_DIR}/lib/open_api"
RENAMED_MODELS="${REPO_ROOT}/scripts/renamed-models.json"  # optional
RENAME_TOOL="${REPO_ROOT}/tools/rename_openapi_models.dart"

PRODUCTS="chat,common,moderation"
API_VERSION="v2"
SPEC_BASENAME="chat-clientside-api"
SPEC_DIR_REL="releases/${API_VERSION}"                              # backend output
PROTOCOL_SPEC_DIR_REL="openapi/${API_VERSION}"                      # protocol input

# ---------- helpers ----------
section() { echo ""; echo "$*"; echo ""; }
# The API version the spec was generated from ('dev' for locally built specs)
spec_version() {
  awk '/^info:/ { in_info = 1; next }
       in_info && /^  version:/ { print $2; exit }
       in_info && /^[^ ]/ { exit }' "$1"
}
# A stable identifier for a checkout: its nearest tag when it has one, else a
# short sha, suffixed with -dirty when the tree carries uncommitted changes.
git_stamp() {
  local dir="$1" rev
  git -C "$dir" rev-parse --git-dir >/dev/null 2>&1 || { echo "unknown"; return; }
  rev="$(git -C "$dir" describe --tags --always 2>/dev/null)"
  [[ -n "$rev" ]] || rev="$(git -C "$dir" rev-parse --short=9 HEAD)"
  [[ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]] && rev="${rev}-dirty"
  echo "$rev"
}

# ---------- validation ----------
[[ -d "$CHAT_BACKEND_DIR" ]] || { echo "❌ CHAT_BACKEND_DIR not found: $CHAT_BACKEND_DIR"; exit 1; }
command -v go   >/dev/null || { echo "❌ 'go' is required in PATH"; exit 1; }
command -v dart >/dev/null || { echo "❌ 'dart' is required in PATH"; exit 1; }

# Optional renamed-models flag
RENAMED_MODELS_FLAG=()
if [[ -f "$RENAMED_MODELS" ]]; then
  RENAMED_MODELS_FLAG=(-renamed-models "$RENAMED_MODELS")
  echo "ℹ️ Using renamed-models.json: $RENAMED_MODELS"
fi

# The spec to generate the client from, resolved by [1/3]. SPEC_FILE is what the
# generator reads, SPEC_ORIGIN the spec it came from — they differ when renames
# are applied to a copy.
SPEC_FILE=""
SPEC_ORIGIN=""
SPEC_API_VERSION=""
SPEC_SOURCE_STAMP=""
SPEC_CHECKSUM=""
SPEC_SOURCE="backend ($CHAT_BACKEND_DIR)"
if [[ -n "$PROTOCOL_DIR" ]]; then
  [[ -d "$PROTOCOL_DIR" ]] || { echo "❌ PROTOCOL_DIR not found: $PROTOCOL_DIR"; exit 1; }
  SPEC_SOURCE="protocol ($PROTOCOL_DIR)"
fi

echo ""
echo "📂 Repo:             $REPO_ROOT"
echo "📦 Package:          $PKG_DIR"
echo "🗂 Output:           $OUTPUT_DIR"
echo "📜 Spec source:      $SPEC_SOURCE"
echo "💬 CHAT_BACKEND_DIR: $CHAT_BACKEND_DIR"
echo ""

# ---------- [1/3] Resolve spec & generate client ----------
section "➡️ [1/3] Resolving OpenAPI spec and generating Dart client…"

if [[ -n "$PROTOCOL_DIR" ]]; then
  # Use the released spec published by the protocol repo as-is. It is generated
  # without the -renamed-models flag, so the renames are applied here instead.
  PROTOCOL_SPEC="${PROTOCOL_DIR}/${PROTOCOL_SPEC_DIR_REL}/${SPEC_BASENAME}"
  for ext in yaml json; do
    [[ -f "${PROTOCOL_SPEC}.${ext}" ]] || {
      echo "❌ Spec not found: ${PROTOCOL_SPEC}.${ext}"
      echo "   Is $PROTOCOL_DIR a checkout of GetStream/protocol?"
      exit 1
    }
  done

  SPEC_ORIGIN="${PROTOCOL_SPEC}.json"
  SPEC_API_VERSION="$(spec_version "${PROTOCOL_SPEC}.yaml")"
  SPEC_SOURCE_STAMP="protocol @ $(git_stamp "$PROTOCOL_DIR")"
  # protocol ships a checksum beside every spec; it identifies the exact bytes
  # even when the checkout sits between tags.
  if [[ -f "${PROTOCOL_SPEC}.json.sha256" ]]; then
    SPEC_CHECKSUM="$(awk '{ print $1; exit }' "${PROTOCOL_SPEC}.json.sha256")"
  fi
  echo "• Using spec $SPEC_ORIGIN (API $SPEC_API_VERSION, $SPEC_SOURCE_STAMP)"

  SPEC_FILE="$SPEC_ORIGIN"
  if [[ -f "$RENAMED_MODELS" ]]; then
    SPEC_TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$SPEC_TMP_DIR"' EXIT

    SPEC_FILE="${SPEC_TMP_DIR}/${SPEC_BASENAME}.json"
    dart "$RENAME_TOOL" "${PROTOCOL_SPEC}.json" "$RENAMED_MODELS" "$SPEC_FILE"
  fi
else
  # Generate a fresh spec (YAML + JSON) from the backend monolith
  (
    set -o pipefail
    cd "$CHAT_BACKEND_DIR/projects/chat-manager"

    go run . openapi generate-spec \
      -products "$PRODUCTS" \
      -version "$API_VERSION" \
      --clientside \
      --encode-time-as-unix-timestamp \
      -output "$CHAT_BACKEND_DIR/$SPEC_DIR_REL/$SPEC_BASENAME" \
      "${RENAMED_MODELS_FLAG[@]}"
  )

  SPEC_FILE="${CHAT_BACKEND_DIR}/${SPEC_DIR_REL}/${SPEC_BASENAME}.yaml"
  SPEC_ORIGIN="$SPEC_FILE"
  SPEC_API_VERSION="$(spec_version "$SPEC_ORIGIN")"
  SPEC_SOURCE_STAMP="backend @ $(git_stamp "$CHAT_BACKEND_DIR")"
  echo "• Generated spec $SPEC_ORIGIN (API $SPEC_API_VERSION, $SPEC_SOURCE_STAMP)"
fi

# Clean target & ensure parent exists
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Generate the Dart client into the package's lib/open_api directory
(
  set -o pipefail
  cd "$CHAT_BACKEND_DIR/projects/chat-manager"

  go run . openapi generate-client \
    --language dart \
    --spec "$SPEC_FILE" \
    --output "$OUTPUT_DIR"
)

# Teach json_serializable and freezed how to handle the WSEvent discriminator.
#
# `EventResponse.event` and `SyncResponse.events` are typed as the WSEvent union,
# which the generator emits with a static `fromJson`, no `toJson`, and no @JsonKey
# converters — json_serializable cannot serialize it, and freezed writes the
# `WsEvent` type argument without the `core.` prefix.
#
# TEMPORARY: remove this once model.tpl emits the converters and models-barrel.tpl
# re-exports WsEvent.
patch_ws_event_models() {
  python3 - "$OUTPUT_DIR" <<'PY'
import pathlib
import sys

output = pathlib.Path(sys.argv[1])

# Expose stream_core's WsEvent so freezed's unprefixed reference resolves.
barrel = output / 'models.dart'
barrel.write_text(
    barrel.read_text().replace(
        'show StreamApiError, StreamDateTimeConverter;',
        'show StreamApiError, StreamDateTimeConverter, WsEvent;',
    )
)

# Converters json_serializable can point at, next to the union itself.
union = output / 'model/ws_event.dart'
union.write_text(union.read_text().rstrip() + '''

WSEvent wsEventFromJson(Map<String, dynamic> json) => WSEvent.fromJson(json);

Map<String, dynamic> wsEventToJson(WSEvent event) =>
    (event.wrapped as dynamic).toJson() as Map<String, dynamic>;

List<WSEvent> wsEventListFromJson(List<dynamic> json) =>
    json.map((e) => wsEventFromJson(e as Map<String, dynamic>)).toList();

List<Map<String, dynamic>> wsEventListToJson(List<WSEvent> events) =>
    events.map(wsEventToJson).toList();
''')

for model, field, converters in [
    ('event_response', 'event', 'wsEventFromJson, toJson: wsEventToJson'),
    ('sync_response', 'events', 'wsEventListFromJson, toJson: wsEventListToJson'),
]:
    path = output / f'model/{model}.dart'
    before = f"@JsonKey(name: '{field}')"
    after = f"@JsonKey(name: '{field}', fromJson: {converters})"
    text = path.read_text()
    if before not in text:
        sys.exit(f'{path}: expected {before} — has the generator been fixed upstream?')
    path.write_text(text.replace(before, after))

print('• Patched the WSEvent discriminator in EventResponse and SyncResponse')
PY
}
patch_ws_event_models

# Record what produced this tree, in the barrel a reader opens first.
#
# The generator stamps no version of its own, so the closest thing to a
# template version is the commit of the monolith that holds the templates. The
# spec carries two of its own: `info.version` is the backend build it was cut
# from, and protocol publishes a sha256 beside each spec that identifies the
# exact bytes even when the checkout sits between tags.
#
# Deliberately free of timestamps — regenerating from unchanged inputs must
# produce no diff.
stamp_provenance() {
  local barrel="$OUTPUT_DIR/api.dart"
  local marker='// Code generated by GetStream internal OpenAPI code generator. DO NOT EDIT.'

  grep -qF -- "$marker" "$barrel" || {
    echo "❌ Generator header not found in $barrel — has the template changed?"
    exit 1
  }

  local checksum_line=""
  [[ -n "$SPEC_CHECKSUM" ]] && checksum_line="// Checksum:  ${SPEC_CHECKSUM}"

  awk -v marker="$marker" \
      -v spec="// Spec:      ${SPEC_BASENAME} (API ${SPEC_API_VERSION})" \
      -v source="// Source:    ${SPEC_SOURCE_STAMP}" \
      -v checksum="$checksum_line" \
      -v generator="// Generator: GetStream/chat @ $(git_stamp "$CHAT_BACKEND_DIR")" '
    { print }
    $0 == marker {
      print "//"
      print spec
      print source
      if (checksum != "") print checksum
      print generator
    }
  ' "$barrel" > "${barrel}.tmp" && mv "${barrel}.tmp" "$barrel"

  echo "• Stamped ${SPEC_BASENAME} (API ${SPEC_API_VERSION}) from ${SPEC_SOURCE_STAMP}"
}
stamp_provenance

section "✅ Finished generating client at: $OUTPUT_DIR"

# ---------- [2/3] build_runner (package only) ----------
section "➡️ [2/3] Running build_runner in stream_chat…"

# A failure still leaves outputs behind, so format them before bailing out
BUILD_RUNNER_OK=1
(
  cd "$PKG_DIR"
  dart run build_runner build
) || BUILD_RUNNER_OK=0

if [[ $BUILD_RUNNER_OK -eq 1 ]]; then
  section "✅ build_runner completed"
else
  section "❌ build_runner failed — see the errors above"
fi

# ---------- [3/3] Format the package ----------
section "➡️ [3/3] Formatting stream_chat…"

(
  cd "$PKG_DIR"
  # build_runner formats every output it writes — including the pre-existing
  # ones — at the dart_style default width, so the whole package needs a pass
  # at the width configured for this repo. Keep logs, ignore exit code.
  dart format . || true
)

section "✅ Formatting completed"

# ---------- summary ----------
[[ $BUILD_RUNNER_OK -eq 1 ]] || { echo "❌ Generation finished with build_runner errors"; exit 1; }

section "🎉 All done!"
echo "• Spec:   $SPEC_ORIGIN"
echo "• Client: $OUTPUT_DIR"
echo ""
