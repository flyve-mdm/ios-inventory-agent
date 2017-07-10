#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  fastlane beta
elif [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "true" ]]; then
  fastlane test
elif [[ "$TRAVIS_BRANCH" == "master" ]]; then
  fastlane test
else
  fastlane test
fi
