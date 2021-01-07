# Stream Chat Dart 

![](https://camo.githubusercontent.com/f5f074f3e1cde523ae0d425347149e20f861024d1d8e19b22053294ad85c43c8/68747470733a2f2f692e696d6775722e636f6d2f4c344d6a3853322e706e67)

This repository contains code for our [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) chat clients.

Stream allows developers to rapidly deploy scalable feeds and chat messaging with an industry leading 99.999% uptime SLA guarantee.

## Structure
Stream Chat Dart is a monorepo built using [Melos](https://docs.page/invertase/melos). Individual packages can be found in the `packages` directory while configuration and top level commands can be found in `melos.yaml`. 

To get started, run `bootstrap` after cloning the project. 

```shell
melos bootstrap
```

## Available Commands 
### Analyze
> Requires `tuneup` to be activated globally. Please see https://pub.dev/packages/tuneup
```shell
melos run analyze
```

### Pub Lint
Runs pub publish with ``--dry-run``
```shell
melos run lint:pub
```

### Build iOS 
Builds iOS examples without codesign 
```shell
melos run build:examples:ios
```

### Build APK
Builds an Android APK for examples
```shell
melos run build:examples:android
```

### Build MACOS
Builds MacOs for all examples
```shell
melos run build:examples:macos
```

### Test
Runs `flutter test` on all packages
```shell
melos run test
```

### Test Web
Runs `flutter test --platform=chrome` on all packages
```shell
melos run test:web
```
