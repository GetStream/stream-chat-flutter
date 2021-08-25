import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// Overrides the default style of [UserListView] descendants.
///
/// See also:
///
///  * [UserListViewThemeData], which is used to configure this theme.
class UserListViewTheme extends InheritedTheme {
  /// Creates a [UserListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const UserListViewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final UserListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [UserListViewTheme] widget, then
  /// [StreamChatThemeData.userListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// UserListViewTheme theme = UserListViewTheme.of(context);
  /// ```
  static UserListViewThemeData of(BuildContext context) {
    final userListViewTheme =
        context.dependOnInheritedWidgetOfExactType<UserListViewTheme>();
    return userListViewTheme?.data ??
        StreamChatTheme.of(context).userListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      UserListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(UserListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [UserListView]s when
/// used with [UserListViewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.userListViewTheme].
///
/// See also:
///
/// * [UserListViewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.userListViewTheme], which can be used to override
/// the default style for [UserListView]s below the overall
/// [StreamChatTheme].
class UserListViewThemeData with Diagnosticable {
  /// Creates a [UserListViewThemeData].
  const UserListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [ChannelListView] background.
  final Color? backgroundColor;

  /// Copies this [ChannelListViewThemeData] to another.
  UserListViewThemeData copyWith({
    Color? backgroundColor,
  }) =>
      UserListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Linearly interpolate between two [UserListViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  UserListViewThemeData lerp(
    UserListViewThemeData a,
    UserListViewThemeData b,
    double t,
  ) =>
      UserListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );

  /// Merges one [UserListViewThemeData] with another.
  UserListViewThemeData merge(UserListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserListViewThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor;

  @override
  int get hashCode => backgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}
