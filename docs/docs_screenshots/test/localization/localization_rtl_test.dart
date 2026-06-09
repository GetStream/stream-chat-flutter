import 'dart:io';

import 'package:device_preview/device_preview.dart' show Devices;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, FontLoader;
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

// SF Arabic is the macOS system Arabic font. It is registered under its own
// named family so that both the Material TextTheme and the StreamTextTheme can
// reference it explicitly via fontFamilyFallback, rather than trying to append
// it to the existing 'CupertinoSystemText' family (which would conflict with
// the SFNS.ttf already registered there by flutter_test_config.dart).
Future<void> _loadSFArabicFont() async {
  final file = File('/System/Library/Fonts/SFArabic.ttf');
  if (!file.existsSync()) return;
  final loader = FontLoader('SFArabic')..addFont(file.readAsBytes().then(ByteData.sublistView));
  await loader.load();
}

// Extends docsScreenshotsTheme() with SFArabic in the fontFamilyFallback of
// both Material's TextTheme and StreamTextTheme so Arabic characters resolve
// to actual glyphs in every widget — including StreamMessageWidget bubbles and
// the StreamChannelHeader title, which use StreamChatTheme text styles.
ThemeData _docsThemeWithArabic() {
  const arabicFallback = ['SFArabic'];

  final streamTextTheme = core.StreamTextTheme().apply(
    color: core.StreamColorScheme.light().systemText,
    fontFamily: 'CupertinoSystemText',
    fontFamilyFallback: arabicFallback,
  );

  final base = docsScreenshotsTheme();
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamilyFallback: arabicFallback),
    extensions: [
      StreamTheme(
        brightness: Brightness.light,
        textTheme: streamTextTheme,
      ),
    ],
  );
}

// A minimal Arabic localizations class that extends the English implementation.
// Only the strings visible in the channel-page screenshot are overridden so
// the UI chrome reads as Arabic. Everything else falls back to English.
class _ArStreamChatLocalizationsDelegate extends LocalizationsDelegate<StreamChatLocalizations> {
  const _ArStreamChatLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<StreamChatLocalizations> load(Locale locale) => SynchronousFuture(const _ArStreamChatLocalizations());

  @override
  bool shouldReload(_ArStreamChatLocalizationsDelegate old) => false;
}

class _ArStreamChatLocalizations extends StreamChatLocalizationsEn {
  const _ArStreamChatLocalizations() : super(localeName: 'ar');

  static const delegate = _ArStreamChatLocalizationsDelegate();

  // Composer placeholder.
  @override
  String get writeAMessageLabel => 'اكتب رسالة…';

  // Channel header subtitle (member count, online status).
  @override
  String membersCountText(int count) {
    if (count == 1) return 'عضو واحد';
    return '$count أعضاء';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return 'متصل واحد';
    return '$count متصلون';
  }

  @override
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members، ${watchersCountText(onlineCount)}';
  }

  @override
  String get userOnlineText => 'متصل';

  @override
  String get userLastOnlineText => 'آخر ظهور';

  // Date dividers.
  @override
  String get todayLabel => 'اليوم';

  @override
  String get yesterdayLabel => 'أمس';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_loadSFArabicFont);

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  docsGoldenTest(
    'channel page in arabic (RTL)',
    fileName: 'localization_rtl_arabic',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    app: (home) => MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        _ArStreamChatLocalizations.delegate,
        ...GlobalStreamChatLocalizations.delegates,
      ],
      theme: _docsThemeWithArabic(),
      debugShowCheckedModeBanner: false,
      home: home,
    ),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'ar-general');
      final channelState = MockChannelState();

      final messages = [
        Message(
          id: 'ar-msg-1',
          text: 'مرحباً! كيف حالك؟',
          user: noahSmith,
          createdAt: DateTime(2024, 6, 1, 10, 0),
        ),
        Message(
          id: 'ar-msg-2',
          text: 'بخير، شكراً! كيف حالك أنت؟',
          user: ownUser,
          createdAt: DateTime(2024, 6, 1, 10, 1),
        ),
        Message(
          id: 'ar-msg-3',
          text: 'هل أنت مستعد للاجتماع اليوم؟',
          user: noahSmith,
          createdAt: DateTime(2024, 6, 1, 10, 5),
        ),
        Message(
          id: 'ar-msg-4',
          text: 'نعم، سأكون هناك في الموعد.',
          user: ownUser,
          createdAt: DateTime(2024, 6, 1, 10, 6),
        ),
      ];

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'القناة العامة',
        messages: messages,
      );
      stubMockClientCurrentUser(client, ownUser);

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            appBar: const StreamChannelHeader(
              automaticallyImplyLeading: false,
              leading: StreamBackButton(showUnreadCount: false),
            ),
            body: Column(
              children: [
                const Expanded(child: StreamMessageListView()),
                StreamMessageComposer(),
              ],
            ),
          ),
        ),
      );
    },
  );
}
