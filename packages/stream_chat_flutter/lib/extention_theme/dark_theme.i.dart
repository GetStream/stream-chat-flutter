import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stream_chat_flutter/extention_theme/theme.i.dart';

/// An implementation that defines the color scheme used in the dark app theme.
class DarkThemeColors implements IThemeColors {
  @override
  Color get greyColor => HexColor('#CCCCCC');

  @override
  Color get redColor => HexColor('#FC4646');

  @override
  Color get greenPrimaryColor => const Color(0xff148F80);

  @override
  Color get dividerColor => HexColor('#292A3B');

  @override
  Color get darkGreyColor => const Color.fromRGBO(34, 34, 34, 1);

  @override
  Color get whiteHintTextColor => HexColor('#CCCCCC').withOpacity(0.8);

  @override
  Color get greenColor => HexColor('#28B446');

  @override
  Color get textFieldColor => HexColor('#0F1419');

  @override
  Color get darkCardColor => HexColor('#1D1E2C');

  @override
  Color get backgroundColor => Colors.black;

  @override
  Color get primaryColor => const Color(0xff148F80);

  @override
  Color get appBarColor => const Color(0xFF181818);

  @override
  Color get appBarTextColor => Colors.white;

  @override
  Color get iconColor => const Color(0xFFCCCCCC);

  @override
  Color get bottomNavigationColor => const Color(0xFF0A070B);

  @override
  Color get accentColor => const Color(0xff48B1BF);

  @override
  Color get postTitleColor => Colors.white;

  @override
  Color get platformSearchIconColor => const Color(0xFFAAA6B9);

  @override
  Color get postSubtitleColor => const Color(0xFF808080);

  @override
  Color get postContentColor => const Color(0xFFCCCCCC);

  @override
  Color get commentTextFieldColor => const Color(0xff282D46);

  @override
  Color get commentTextColor => const Color(0xFF536471);

  @override
  Color get textFieldBorderColor => const Color(0XFF524B6C);

  @override
  Color get textFieldHintColor => const Color(0xFF808080);

  @override
  Color get textHeadingColor => const Color(0xFF808D8E);

  @override
  Color get yellowColor => const Color(0xFFE8B261);

  @override
  Color get darkHintColor => const Color(0xFFAAA6B9);

  @override
  Color get markAsReadColor => Colors.blue;

  @override
  Color get messageSentIndicatorColor => Colors.white;
}
