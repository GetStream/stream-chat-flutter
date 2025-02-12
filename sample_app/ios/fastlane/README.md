fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### match_me
```
fastlane match_me
```
Installs all Certs and Profiles necessary for development and ad-hoc
### match_appstore
```
fastlane match_appstore
```
Installs all Certs and Profiles necessary for appstore

----

## iOS
### ios deploy_to_firebase
```
fastlane ios deploy_to_firebase
```
Deploy build to Firebase
### ios deploy_to_testflight
```
fastlane ios deploy_to_testflight
```
Deploy build to TestFlight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
