# platform_widget_builder

This package is a more specialized version of the [flutter_platform_widgets](https://pub.dev/packages/flutter_platform_widgets) package.
It provides two specialized widget builders:
* `PlatformWidgetBuilder`
* `DesktopWidgetBuilder`

### `PlatformWidgetBuilder`
This widget differs from the `PlatformWidgetBuilder` found in the `flutter_platform_widgets` package in that it
provides three builders:
* `mobile`
* `desktop`
* `web`

This allows developers to build different widgets for their generalized platform targets 
 (Android + iOS = mobile, macOS + Windows + Linux = desktop). This is advantageous when requirements call for one set 
of widgets that are identical across mobile, a different set of widgets that are identical across desktop, and another
that are required for web.

### `DesktopWidgetBuilder`
This widget is more specialized than `PlatformWidgetBuilder` in that it allows for more targeted widget-building for
desktop platforms. It provides three builders:
* `macOS`
* `windows`
* `linux`

This allows developers to build different widgets for the various desktop platforms. This is advantageous when building
native-looking desktop applications using the `macos_ui`, `fluent_ui`, and `yaru_widgets` packages.
