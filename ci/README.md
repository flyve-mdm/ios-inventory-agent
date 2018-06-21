# Continuous Integration with Circle CI script and files

Here is placed files and bash script required to build, test and deploy the app with Circle CI

## Files description

- exportPlist.plist info the app to deploy required by fastlane

## Workflow description

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

#### Environment variables

On this project we use the following environment variables:

- app_info, build, deploy_develop, deploy_master
  - APPNAME -> The name of the app (InventoryAgent)
- fastlane_config
  - APPLE_ID           -> Developer Apple ID
  - APPLE_TEAM_ID      -> Developer Apple Team ID
  - APP_IDENTIFIER     -> The identifier of the app for the store
  - FASTLANE_PASSWORD  -> Password required by Fastlane
  - TELEGRAM_WEBHOOKS  -> Used to send notifications to Telegram
  - XCODE_SCHEME       -> Set the Scheme for the Inventory Agent
  - XCODE_SCHEME_UI    -> Set the Scheme for the UI
  - XCODE_WORKSPACE    -> Define the workspace of the project
- git_config, deploy_master
  - $GITHUB_EMAIL  -> GitHub Email
  - $GITHUB_USER   -> GitHub User
  - $GITHUB_TOKEN  -> GitHub Token
- keychain_add, keychain_remove
  - KEYCHAIN_PASSWORD  -> Password for the keychain, required to sign the app
  - KEYCHAIN_NAME      -> Name of the keychain, required to sign the app
- transifex
  - $TRANSIFEX_USER       -> User of Transifex
  - $TRANSIFEX_API_TOKEN  -> API Token of Transifex

## Libraries

We use the following:

- [conventional-github-releaser](https://github.com/conventional-changelog/releaser-tools)
- [gh-pages](https://github.com/tschaub/gh-pages)
- [node-github-releaser](https://github.com/miyajan/node-github-release)
- [standard-version](https://github.com/conventional-changelog/standard-version)