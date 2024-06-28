#!/bin/bash

LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`) 2> /dev/null
if [ -z $LATEST_TAG ]; then
  echo "1.0.0+1"
  exit 0
fi

LATEST_TAG_VERSION=""
LATEST_TAG_MAJOR=""
LATEST_TAG_MINOR=""
LATEST_TAG_PATCH=""
LATEST_TAG_BUILD=""
if [[ $LATEST_TAG =~ v([0-9]+)\.([0-9]+)\.([0-9]+)\+?([0-9]+)? ]]; then
  LATEST_TAG_MAJOR=${BASH_REMATCH[1]}
  LATEST_TAG_MINOR=${BASH_REMATCH[2]}
  LATEST_TAG_PATCH=${BASH_REMATCH[3]}
  LATEST_TAG_BUILD=${BASH_REMATCH[4]}
  if [ -z $LATEST_TAG_BUILD ]; then
    LATEST_TAG_VERSION=$LATEST_TAG_MAJOR.$LATEST_TAG_MINOR.$LATEST_TAG_PATCH
  else
    LATEST_TAG_VERSION=$LATEST_TAG_MAJOR.$LATEST_TAG_MINOR.$LATEST_TAG_PATCH+$LATEST_TAG_BUILD
  fi
else
  echo "Could not extract latest version, incorrectly formatted tag!"
  exit 1
fi

PUBSPEC_VERSION=""
PUBSPEC_MAJOR=""
PUBSPEC_MINOR=""
PUBSPEC_PATCH=""
if [[ `cat pubspec.yaml` =~ (version\:[ ]?)([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
  PUBSPEC_MAJOR=${BASH_REMATCH[2]}
  PUBSPEC_MINOR=${BASH_REMATCH[3]}
  PUBSPEC_PATCH=${BASH_REMATCH[4]}
  PUBSPEC_VERSION=$PUBSPEC_MAJOR.$PUBSPEC_MINOR.$PUBSPEC_PATCH
else
  echo "Failed to extract version from pubspec.yaml"
  exit 1
fi

TAG_VERSION_NUM="${LATEST_TAG_MAJOR}${LATEST_TAG_MINOR}${LATEST_TAG_PATCH}"
PUBSPEC_VERSION_NUM="${PUBSPEC_MAJOR}${PUBSPEC_MINOR}${PUBSPEC_PATCH}"
if (( $TAG_VERSION_NUM > $PUBSPEC_VERSION_NUM )); then
  echo "The new major version cannot be lower than the previous major version"
  echo "Latest major: ${PUBSPEC_MAJOR}"
  echo "Previous major: ${LATEST_TAG_MAJOR}"
  exit 1
fi

FINAL_MAJOR=$PUBSPEC_MAJOR
FINAL_MINOR=$PUBSPEC_MINOR
FINAL_PATCH=$PUBSPEC_PATCH
FINAL_BUILD=""
if [[ $LATEST_TAG_MAJOR == $PUBSPEC_MAJOR && $LATEST_TAG_MINOR == $PUBSPEC_MINOR && $LATEST_TAG_PATCH == $PUBSPEC_PATCH ]]; then
  if [ -z $LATEST_TAG_BUILD ]; then
    FINAL_BUILD="1"
  else
    FINAL_BUILD=$(($LATEST_TAG_BUILD + 1))
  fi
else
  FINAL_BUILD="1"
fi

echo $FINAL_MAJOR.$FINAL_MINOR.$FINAL_PATCH+$FINAL_BUILD