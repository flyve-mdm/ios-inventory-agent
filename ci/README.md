# Continuous Integration with Circle CI script and files 

Here is placed files and bash script required to build, test and deploy the app with Circle CI

## Files description:

- exportPlist.plist info the app to deploy required by fastlane

## Workflow description:

#### On machine

- Configure environment variables
- Use xcode 8.3

#### On checkout

- Update git tags

#### On dependencies

- Configure bundler (scripts/bundler_config.sh)
- install dependencies for deploy (scripts/install.sh)

#### On test

- Configure fastlane environment variables (scripts/fastlane_config.sh)
- Global configuration git (scripts/git_config.sh)
- Configure, push and pull languages from Transifex (scripts/transifex.sh)
- Create keychain (scripts/keychain_add.sh)
- Run Build on feature branch or run test on develop or master branch (scripts/test.sh)

#### On deploy_develop

- Generate new tag with standard-version (scripts/deploy_develop.sh)
- Update version and build (scripts/deploy_develop.sh)
- Generate documentation with jazzy (scripts/deploy_develop.sh)
- Generate code coverage reporting with xcov (scripts/deploy_develop.sh)
- Deploy beta version to TestFlight (scripts/deploy_develop.sh)
- Remove keychain (scripts/keychain_remove.sh) 

#### On deploy_master

- Generate new tag with standard-version (scripts/deploy_master.sh)
- Update version and build (scripts/deploy_master.sh)
- Create a github release (scripts/deploy_master.sh)
- Update CHANGELOG.md on gh-pages branch (scripts/deploy_master.sh)
- Deploy release version to App Store (scripts/deploy_master.sh)
- Remove keychain (scripts/keychain_remove.sh)
