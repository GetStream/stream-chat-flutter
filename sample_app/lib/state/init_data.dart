import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// {@template init_notifier}
/// [ChangeNotifier] to store [InitData] and notify listeners on change.
/// {@endtemplate}
class InitNotifier extends ChangeNotifier {
  /// {@macro init_notifier}
  InitNotifier();

  InitData? _initData;

  set initData(InitData? data) {
    _initData = data;
    notifyListeners();
  }

  InitData? get initData => _initData;
}

/// {@template init_data}
/// Manages the initialization data for the sample application.
///
/// Stores a reference to the current [StreamChatClient].
/// {@endtemplate}
class InitData {
  /// {@macro init_data}
  InitData(this.client, this.preferences);

  final StreamChatClient client;
  final StreamingSharedPreferences preferences;

  InitData copyWith({required StreamChatClient client}) => InitData(client, preferences);
}
