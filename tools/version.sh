#!/bin/bash

if ! command -v melos &> /dev/null
then
    echo "melos could not be found"
    exit 1
fi

if ! command -v yq &> /dev/null
then
    echo "yq could not be found"
    exit 1
fi

if [ $# -eq 0 ]
  then
    echo "You must provide a version number"
    echo "Usage: ./tools/version.sh 1.0.0"
    exit 1
fi

VERSION=$1

echo "Checking melos.yaml for packages"

PACKAGES_PATH=$(yq eval '.packages' melos.yaml | tr -d '-' | tr -d '*')
PACKAGES=$(cd $PACKAGES_PATH  && ls -d */ | tr -d '/')

COMMAND="melos version --no-git-tag-version --no-changelog"

for PACKAGE in $PACKAGES
do
  echo "Setting version $VERSION for $PACKAGE"
  COMMAND+=" -V $PACKAGE:$VERSION"
done

eval $COMMAND

VERSION_FILE=$PWD/packages/stream_chat/lib/version.dart

echo "Updating $VERSION_FILE"

echo "$(cat $VERSION_FILE | sed -E "s/[0-9]+\.[0-9]+\.[0-9]+/$VERSION/g")" > $PWD/packages/stream_chat/lib/version.dart