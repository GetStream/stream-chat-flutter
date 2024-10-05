import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/extention_theme/dark_theme.i.dart';

/// An interface that defines the color scheme used in the app theme.
abstract class IThemeColors {
  /// The color used for grey elements in the theme.
  Color get greyColor;

  /// The color used for red elements in the theme.
  Color get redColor;

  /// The primary green color used in the theme.
  Color get greenPrimaryColor;

  /// The color used for dividers in the theme.
  Color get dividerColor;

  /// The color used for dark grey elements in the theme.
  Color get darkGreyColor;

  /// The color used for white hint text in the theme.
  Color get whiteHintTextColor;

  /// The color used for green elements in the theme.
  Color get greenColor;

  /// The color used for text fields in the theme.
  Color get textFieldColor;

  /// The color used for dark card backgrounds in the theme.
  Color get darkCardColor;

  /// The background color of the app.
  Color get backgroundColor;

  /// The primary color of the app.
  Color get primaryColor;

  /// The color used for the app bar background.
  Color get appBarColor;

  /// The color used for the text in the app bar.
  Color get appBarTextColor;

  /// The color used for icons in the theme.
  Color get iconColor;

  /// The color used for the background of the bottom navigation bar.
  Color get bottomNavigationColor;

  /// The accent color of the app.
  Color get accentColor;

  /// The color used for post titles.
  Color get postTitleColor;

  /// The color used for the platform search icon.
  Color get platformSearchIconColor;

  /// The color used for post subtitles.
  Color get postSubtitleColor;

  /// The color used for post content text.
  Color get postContentColor;

  /// The color used for the background of the comment text field.
  Color get commentTextFieldColor;

  /// The color used for comment text.
  Color get commentTextColor;

  /// The color used for text field borders.
  Color get textFieldBorderColor;

  /// The color used for text field hints.
  Color get textFieldHintColor;

  /// The color used for text headings.
  Color get textHeadingColor;

  /// The yellow color used in the theme.
  Color get yellowColor;

  /// The color used for dark hints in the theme.
  Color get darkHintColor;

  /// The color used for dark hints in the theme.
  Color get markAsReadColor;

  /// The color used for dark hints in the theme.
  Color get messageSentIndicatorColor;
}

//Adding ChatTheme extension to StreamChatThemeData
extension ChatTheme on StreamChatThemeData {
  IThemeColors get chatTheme => DarkThemeColors();

  // {

  //   final brightness = colorTheme.brightness;

  //   // Return Light or Dark theme colors based on the brightness
  //   if (brightness == Brightness.dark) {
  //     return DarkThemeColors();
  //   } else {
  //     return LightThemeColors();
  //   }
  // }
}

    // final IThemeColors themeColors = StreamChatTheme.of(context).chatTheme;

