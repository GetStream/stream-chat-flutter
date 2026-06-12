import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

// ---------------------------------------------------------------------------
// AppStyle enum
// ---------------------------------------------------------------------------

/// The visual style for the app's UI chrome (app bar, composer, bottom bar).
enum SampleAppStyle {
  /// Standard docked composer with solid app bar and bottom bar.
  regular,

  /// Floating composer with translucent overlapping chrome.
  floating,
}

// ---------------------------------------------------------------------------
// Preference keys
// ---------------------------------------------------------------------------

const _kThemeMode = 'config.themeMode';
const _kAppStyle = 'config.appStyle';
const _kForceRtl = 'config.forceRtl';
const _kEnableReminderActions = 'config.enableReminderActions';
const _kEnableDeleteForMe = 'config.enableDeleteForMe';
const _kEnableMessageInfo = 'config.enableMessageInfo';
const _kEnableLocationSharing = 'config.enableLocationSharing';
const _kDraftMessagesEnabled = 'config.draftMessagesEnabled';
const _kEnforceUniqueReactions = 'config.enforceUniqueReactions';
const _kReactionType = 'config.reactionType';
const _kReactionPosition = 'config.reactionPosition';
const _kLocale = 'config.locale';

const _sentinel = Object();

/// Locales supported by the sample app, derived from
/// [kStreamChatSupportedLanguages].
final supportedLocales = kStreamChatSupportedLanguages.map(Locale.new).toList();

// ---------------------------------------------------------------------------
// SampleAppConfigData
// ---------------------------------------------------------------------------

/// Immutable configuration data for the sample app.
///
/// Holds both sample-app-specific flags and chat configuration flags.
@immutable
class SampleAppConfigData {
  /// Creates a configuration with sensible defaults.
  factory SampleAppConfigData({
    Locale? locale,
    ThemeMode themeMode = .system,
    SampleAppStyle appStyle = .floating,
    bool forceRtl = false,
    bool enableReminderActions = false,
    bool enableDeleteForMe = false,
    bool enableMessageInfo = false,
    bool enableLocationSharing = false,
    bool draftMessagesEnabled = true,
    bool enforceUniqueReactions = false,
    StreamReactionsType? reactionType,
    StreamReactionsPosition? reactionPosition,
  }) {
    return SampleAppConfigData.raw(
      themeMode: themeMode,
      appStyle: appStyle,
      locale: locale,
      forceRtl: forceRtl,
      enableReminderActions: enableReminderActions,
      enableDeleteForMe: enableDeleteForMe,
      enableMessageInfo: enableMessageInfo,
      enableLocationSharing: enableLocationSharing,
      draftMessagesEnabled: draftMessagesEnabled,
      enforceUniqueReactions: enforceUniqueReactions,
      reactionType: reactionType,
      reactionPosition: reactionPosition,
    );
  }

  /// Raw constructor used internally and by persistence.
  const SampleAppConfigData.raw({
    required this.themeMode,
    required this.appStyle,
    required this.locale,
    required this.forceRtl,
    required this.enableReminderActions,
    required this.enableDeleteForMe,
    required this.enableMessageInfo,
    required this.enableLocationSharing,
    required this.draftMessagesEnabled,
    required this.enforceUniqueReactions,
    required this.reactionType,
    required this.reactionPosition,
  });

  /// Loads config from [StreamingSharedPreferences], falling back to defaults.
  factory SampleAppConfigData.fromPreferences(StreamingSharedPreferences prefs) {
    final localeStr = prefs.getString(_kLocale, defaultValue: '').getValue();
    final appStyleIndex = prefs.getInt(_kAppStyle, defaultValue: SampleAppStyle.floating.index).getValue();
    return SampleAppConfigData.raw(
      themeMode: ThemeMode.values[prefs.getInt(_kThemeMode, defaultValue: ThemeMode.system.index).getValue()],
      appStyle: SampleAppStyle.values[appStyleIndex.clamp(0, SampleAppStyle.values.length - 1)],
      locale: localeStr.isEmpty ? null : Locale(localeStr),
      forceRtl: prefs.getBool(_kForceRtl, defaultValue: false).getValue(),
      enableReminderActions: prefs.getBool(_kEnableReminderActions, defaultValue: false).getValue(),
      enableDeleteForMe: prefs.getBool(_kEnableDeleteForMe, defaultValue: false).getValue(),
      enableMessageInfo: prefs.getBool(_kEnableMessageInfo, defaultValue: false).getValue(),
      enableLocationSharing: prefs.getBool(_kEnableLocationSharing, defaultValue: false).getValue(),
      draftMessagesEnabled: prefs.getBool(_kDraftMessagesEnabled, defaultValue: false).getValue(),
      enforceUniqueReactions: prefs.getBool(_kEnforceUniqueReactions, defaultValue: false).getValue(),
      reactionType: _intToReactionType(prefs.getInt(_kReactionType, defaultValue: -1).getValue()),
      reactionPosition: _intToReactionPosition(prefs.getInt(_kReactionPosition, defaultValue: -1).getValue()),
    );
  }

  // -- Sample-app-only flags ------------------------------------------------

  /// The theme mode for the app (system, light, dark).
  final ThemeMode themeMode;

  /// The visual style for the app chrome (app bar, composer, bottom bar).
  final SampleAppStyle appStyle;

  /// The locale override for the app. When null, the system locale is used.
  final Locale? locale;

  /// Whether to force RTL layout direction.
  final bool forceRtl;

  /// Whether reminder actions appear in the message context menu.
  final bool enableReminderActions;

  /// Whether the "Delete for Me" action appears in the message context menu.
  final bool enableDeleteForMe;

  /// Whether the "Message Info" action appears in the message context menu.
  final bool enableMessageInfo;

  /// Whether location sharing (attachment builder + picker) is enabled.
  final bool enableLocationSharing;

  // -- Chat config flags ----------------------------------------------------

  /// Whether draft messages are enabled.
  final bool draftMessagesEnabled;

  /// Whether a new reaction replaces the existing one.
  final bool enforceUniqueReactions;

  /// The visual type of the reactions display.
  final StreamReactionsType? reactionType;

  /// Where reactions appear relative to the message bubble.
  final StreamReactionsPosition? reactionPosition;

  // -- copyWith -------------------------------------------------------------

  /// Creates a copy with the given fields replaced.
  ///
  /// For nullable fields ([locale], [reactionType], [reactionPosition]),
  /// pass explicitly as `null` to reset to default/system.
  SampleAppConfigData copyWith({
    ThemeMode? themeMode,
    SampleAppStyle? appStyle,
    Object? locale = _sentinel,
    bool? forceRtl,
    bool? enableReminderActions,
    bool? enableDeleteForMe,
    bool? enableMessageInfo,
    bool? enableLocationSharing,
    bool? draftMessagesEnabled,
    bool? enforceUniqueReactions,
    Object? reactionType = _sentinel,
    Object? reactionPosition = _sentinel,
  }) {
    return SampleAppConfigData.raw(
      themeMode: themeMode ?? this.themeMode,
      appStyle: appStyle ?? this.appStyle,
      locale: locale == _sentinel ? this.locale : locale as Locale?,
      forceRtl: forceRtl ?? this.forceRtl,
      enableReminderActions: enableReminderActions ?? this.enableReminderActions,
      enableDeleteForMe: enableDeleteForMe ?? this.enableDeleteForMe,
      enableMessageInfo: enableMessageInfo ?? this.enableMessageInfo,
      enableLocationSharing: enableLocationSharing ?? this.enableLocationSharing,
      draftMessagesEnabled: draftMessagesEnabled ?? this.draftMessagesEnabled,
      enforceUniqueReactions: enforceUniqueReactions ?? this.enforceUniqueReactions,
      reactionType: reactionType == _sentinel ? this.reactionType : reactionType as StreamReactionsType?,
      reactionPosition: reactionPosition == _sentinel
          ? this.reactionPosition
          : reactionPosition as StreamReactionsPosition?,
    );
  }

  // -- Persistence ----------------------------------------------------------

  /// Persists all fields to [StreamingSharedPreferences].
  void saveToPreferences(StreamingSharedPreferences prefs) {
    prefs.setInt(_kThemeMode, themeMode.index);
    prefs.setInt(_kAppStyle, appStyle.index);
    prefs.setString(_kLocale, locale?.languageCode ?? '');
    prefs.setBool(_kForceRtl, forceRtl);
    prefs.setBool(_kEnableReminderActions, enableReminderActions);
    prefs.setBool(_kEnableDeleteForMe, enableDeleteForMe);
    prefs.setBool(_kEnableMessageInfo, enableMessageInfo);
    prefs.setBool(_kEnableLocationSharing, enableLocationSharing);
    prefs.setBool(_kDraftMessagesEnabled, draftMessagesEnabled);
    prefs.setBool(_kEnforceUniqueReactions, enforceUniqueReactions);
    prefs.setInt(_kReactionType, _reactionTypeToInt(reactionType));
    prefs.setInt(_kReactionPosition, _reactionPositionToInt(reactionPosition));
  }

  static StreamReactionsType? _intToReactionType(int value) {
    if (value < 0 || value >= StreamReactionsType.values.length) return null;
    return StreamReactionsType.values[value];
  }

  static StreamReactionsPosition? _intToReactionPosition(int value) {
    if (value < 0 || value >= StreamReactionsPosition.values.length) return null;
    return StreamReactionsPosition.values[value];
  }

  static int _reactionTypeToInt(StreamReactionsType? type) => type?.index ?? -1;

  static int _reactionPositionToInt(StreamReactionsPosition? position) => position?.index ?? -1;
}

// ---------------------------------------------------------------------------
// SampleAppConfig (StatefulWidget + InheritedWidget)
// ---------------------------------------------------------------------------

/// Provides [SampleAppConfigData] to the widget tree and manages mutable state.
///
/// Wraps its child in a private [_SampleAppConfigScope] [InheritedWidget].
/// Access the config via [SampleAppConfig.of] or the [SampleAppConfigExtension].
class SampleAppConfig extends StatefulWidget {
  /// Creates a sample app config provider.
  const SampleAppConfig({
    super.key,
    required this.preferences,
    this.initialConfig,
    required this.child,
  });

  /// The shared preferences instance used for persistence.
  final StreamingSharedPreferences preferences;

  /// The initial configuration. If null, defaults are loaded from [preferences].
  final SampleAppConfigData? initialConfig;

  /// The child widget.
  final Widget child;

  /// Returns the [SampleAppConfigData] from the nearest ancestor, or defaults.
  static SampleAppConfigData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SampleAppConfigScope>();
    return scope?.config ?? SampleAppConfigData();
  }

  /// Updates the config in the nearest ancestor [SampleAppConfig].
  static void update(BuildContext context, SampleAppConfigData config) {
    context.findAncestorStateOfType<_SampleAppConfigState>()?.update(config);
  }

  @override
  State<SampleAppConfig> createState() => _SampleAppConfigState();
}

class _SampleAppConfigState extends State<SampleAppConfig> {
  late SampleAppConfigData _config;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig ?? SampleAppConfigData.fromPreferences(widget.preferences);
  }

  void update(SampleAppConfigData config) {
    setState(() => _config = config);
    config.saveToPreferences(widget.preferences);
  }

  @override
  Widget build(BuildContext context) {
    return _SampleAppConfigScope(
      config: _config,
      child: widget.child,
    );
  }
}

class _SampleAppConfigScope extends InheritedWidget {
  const _SampleAppConfigScope({
    required this.config,
    required super.child,
  });

  final SampleAppConfigData config;

  @override
  bool updateShouldNotify(_SampleAppConfigScope oldWidget) {
    return config != oldWidget.config;
  }
}

// ---------------------------------------------------------------------------
// BuildContext extension
// ---------------------------------------------------------------------------

/// Convenient access to [SampleAppConfigData] from any [BuildContext].
extension SampleAppConfigExtension on BuildContext {
  /// Returns the [SampleAppConfigData] from the nearest [SampleAppConfig].
  SampleAppConfigData get sampleAppConfig => SampleAppConfig.of(this);
}
