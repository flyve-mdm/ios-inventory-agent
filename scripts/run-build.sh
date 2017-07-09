#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
  fastlane beta
elif [[ "$TRAVIS_BRANCH" == "master" ]]; then
  fastlane release
else
  fastlane test
fi
