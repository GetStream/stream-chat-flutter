// ignore_for_file: public_member_api_docs, use_super_parameters

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/material.dart';

import 'mocks.dart';

class MaterialAppWrapper extends MaterialApp {
  MaterialAppWrapper({
    Key? key,
    TargetPlatform platform = TargetPlatform.android,
    Iterable<LocalizationsDelegate<dynamic>>? localizations,
    NavigatorObserver? navigatorObserver,
    Iterable<Locale>? localeOverrides,
    ThemeData? theme,
    TransitionBuilder? builder,
    Widget? home,
  }) : super(
          key: key,
          builder: builder,
          localizationsDelegates: localizations,
          supportedLocales: localeOverrides ?? const [Locale('en')],
          theme: theme?.copyWith(platform: platform) ??
              ThemeData(platform: platform, useMaterial3: false),
          debugShowCheckedModeBanner: false,
          home: home,
          navigatorObservers: [
            if (navigatorObserver != null) navigatorObserver,
          ],
        ) {
    ConnectivityPlatform.instance = MockConnectivityPlatform();
  }
}
