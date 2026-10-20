#!/usr/bin/env bash
#
# Moves sample_app's Android project to AGP 9 with built-in Kotlin, the setup
# `flutter create` generates for new apps, so CI can build it alongside the
# committed AGP 8 setup. Fails if any edit does not apply, so the build never
# silently runs on the old setup.

set -euo pipefail

AGP_VERSION="9.1.0"
GRADLE_VERSION="9.3.1"
# Built-in Kotlin uses the Kotlin Gradle Plugin on the build classpath, and the
# one AGP bundles is older than Flutter's minimum.
KGP_VERSION="2.4.0"

cd "$(dirname "$0")/../../../sample_app/android"

# Replaces with a Perl regex in a file, failing when nothing matched.
replace() {
  local file="$1" pattern="$2" replacement="$3"
  PATTERN="$pattern" REPLACEMENT="$replacement" perl -0pi -e '
    $n = s/$ENV{PATTERN}/$ENV{REPLACEMENT}/gm;
    END { exit($n ? 0 : 1) }
  ' "$file" || { echo "error: no match for /$pattern/ in $file" >&2; exit 1; }
}

replace settings.gradle \
  'id "com.android.application" version "[^"]+"' \
  "id \"com.android.application\" version \"$AGP_VERSION\""
replace settings.gradle \
  'id "org.jetbrains.kotlin.android" version "[^"]+"' \
  "id \"org.jetbrains.kotlin.android\" version \"$KGP_VERSION\""

replace gradle/wrapper/gradle-wrapper.properties \
  'gradle-[0-9.]+-bin\.zip' \
  "gradle-$GRADLE_VERSION-bin.zip"

replace gradle.properties \
  '^android\.builtInKotlin=false$' \
  'android.builtInKotlin=true'

replace app/build.gradle \
  '^[ \t]*id "kotlin-android"\n' \
  ''
replace app/build.gradle \
  '^[ \t]*kotlinOptions \{\n[ \t]*jvmTarget = [^\n]+\n[ \t]*\}\n\n' \
  ''
replace app/build.gradle \
  '^flutter \{' \
  $'kotlin {\n    compilerOptions {\n        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17\n    }\n}\n\nflutter {'

echo "sample_app/android now uses AGP $AGP_VERSION, Gradle $GRADLE_VERSION and built-in Kotlin."
