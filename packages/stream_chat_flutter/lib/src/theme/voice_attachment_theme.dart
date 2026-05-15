import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template StreamVoiceRecordingThemeData}
/// The theme data for the voice recording attachment builder.
/// {@endtemplate}
@Deprecated("Use 'StreamVoiceRecordingAttachmentThemeData' instead.")
class StreamVoiceRecordingThemeData with Diagnosticable {
  /// {@macro StreamVoiceRecordingThemeData}
  const StreamVoiceRecordingThemeData({
    required this.loadingTheme,
    required this.sliderTheme,
    required this.listPlayerTheme,
    required this.playerTheme,
  });

  /// {@template ThemeDataLight}
  /// Creates a theme data with light values.
  /// {@endtemplate}
  factory StreamVoiceRecordingThemeData.light() {
    return StreamVoiceRecordingThemeData(
      loadingTheme: StreamVoiceRecordingLoadingThemeData.light(),
      sliderTheme: StreamVoiceRecordingSliderTheme.light(),
      listPlayerTheme: StreamVoiceRecordingListPlayerThemeData.light(),
      playerTheme: StreamVoiceRecordingPlayerThemeData.light(),
    );
  }

  /// {@template ThemeDataDark}
  /// Creates a theme data with dark values.
  /// {@endtemplate}
  factory StreamVoiceRecordingThemeData.dark() {
    return StreamVoiceRecordingThemeData(
      loadingTheme: StreamVoiceRecordingLoadingThemeData.dark(),
      sliderTheme: StreamVoiceRecordingSliderTheme.dark(),
      listPlayerTheme: StreamVoiceRecordingListPlayerThemeData.dark(),
      playerTheme: StreamVoiceRecordingPlayerThemeData.dark(),
    );
  }

  /// The theme for the loading widget.
  final StreamVoiceRecordingLoadingThemeData loadingTheme;

  /// The theme for the slider widget.
  final StreamVoiceRecordingSliderTheme sliderTheme;

  /// The theme for the list player widget.
  final StreamVoiceRecordingListPlayerThemeData listPlayerTheme;

  /// The theme for the player widget.
  final StreamVoiceRecordingPlayerThemeData playerTheme;

  /// {@template ThemeDataMerge}
  /// Used to merge the values of another theme data object into this.
  /// {@endtemplate}
  StreamVoiceRecordingThemeData merge(StreamVoiceRecordingThemeData? other) {
    if (other == null) return this;
    return StreamVoiceRecordingThemeData(
      loadingTheme: loadingTheme.merge(other.loadingTheme),
      sliderTheme: sliderTheme.merge(other.sliderTheme),
      listPlayerTheme: listPlayerTheme.merge(other.listPlayerTheme),
      playerTheme: playerTheme.merge(other.playerTheme),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('loadingTheme', loadingTheme))
      ..add(DiagnosticsProperty('sliderTheme', sliderTheme))
      ..add(DiagnosticsProperty('listPlayerTheme', listPlayerTheme))
      ..add(DiagnosticsProperty('playerTheme', playerTheme));
  }
}

/// {@template StreamAudioPlayerLoadingTheme}
/// The theme data for the voice recording attachment builder
/// loading widget [StreamVoiceRecordingLoading].
/// {@endtemplate}
@Deprecated("Use 'StreamVoiceRecordingAttachmentThemeData' instead.")
class StreamVoiceRecordingLoadingThemeData with Diagnosticable {
  /// {@macro StreamAudioPlayerLoadingTheme}
  const StreamVoiceRecordingLoadingThemeData({
    this.size,
    this.strokeWidth,
    this.color,
    this.padding,
  });

  /// {@macro ThemeDataLight}
  factory StreamVoiceRecordingLoadingThemeData.light() {
    return const StreamVoiceRecordingLoadingThemeData(
      size: Size(20, 20),
      strokeWidth: 2,
      color: Color(0xFF005FFF),
      padding: EdgeInsets.all(8),
    );
  }

  /// {@macro ThemeDataDark}
  factory StreamVoiceRecordingLoadingThemeData.dark() {
    return const StreamVoiceRecordingLoadingThemeData(
      size: Size(20, 20),
      strokeWidth: 2,
      color: Color(0xFF005FFF),
      padding: EdgeInsets.all(8),
    );
  }

  /// The size of the loading indicator.
  final Size? size;

  /// The stroke width of the loading indicator.
  final double? strokeWidth;

  /// The color of the loading indicator.
  final Color? color;

  /// The padding around the loading indicator.
  final EdgeInsets? padding;

  /// {@macro ThemeDataMerge}
  StreamVoiceRecordingLoadingThemeData merge(
      StreamVoiceRecordingLoadingThemeData? other) {
    if (other == null) return this;
    return StreamVoiceRecordingLoadingThemeData(
      size: other.size,
      strokeWidth: other.strokeWidth,
      color: other.color,
      padding: other.padding,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('strokeWidth', strokeWidth))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty('padding', padding));
  }
}

/// {@template StreamAudioPlayerSliderTheme}
/// The theme data for the voice recording attachment builder audio player
/// slider [StreamVoiceRecordingSlider].
/// {@endtemplate}
@Deprecated("Use 'StreamVoiceRecordingAttachmentThemeData' instead.")
class StreamVoiceRecordingSliderTheme with Diagnosticable {
  /// {@macro StreamAudioPlayerSliderTheme}
  const StreamVoiceRecordingSliderTheme({
    this.horizontalPadding = 10,
    this.spacingRatio = 0.007,
    this.waveHeightRatio = 1,
    this.buttonBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.buttonColor,
    this.buttonBorderColor,
    this.buttonBorderWidth = 1,
    this.waveColorPlayed,
    this.waveColorUnplayed,
    this.buttonShadow = const BoxShadow(
      color: Color(0x33000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  });

  /// {@macro ThemeDataLight}
  factory StreamVoiceRecordingSliderTheme.light() {
    return const StreamVoiceRecordingSliderTheme(
      buttonColor: Color(0xFFFFFFFF),
      buttonBorderColor: Color(0x3308070733),
      waveColorPlayed: Color(0xFF005DFF),
      waveColorUnplayed: Color(0xFF7E828B),
    );
  }

  /// {@macro ThemeDataDark}
  factory StreamVoiceRecordingSliderTheme.dark() {
    return const StreamVoiceRecordingSliderTheme(
      buttonColor: Color(0xFF005FFF),
      buttonBorderColor: Color(0x3308070766),
      waveColorPlayed: Color(0xFF337EFF),
      waveColorUnplayed: Color(0xFF7E828B),
    );
  }

  /// The color of the slider button.
  final Color? buttonColor;

  /// The color of the border of the slider button.
  final Color? buttonBorderColor;

  /// The width of the border of the slider button.
  final double? buttonBorderWidth;

  /// The shadow of the slider button.
  final BoxShadow? buttonShadow;

  /// The border radius of the slider button.
  final BorderRadius buttonBorderRadius;

  /// The horizontal padding of the slider.
  final double horizontalPadding;

  /// Spacing ratios. This is the percentage that the space takes from the whole
  /// available space. Typically this value should be between 0.003 to 0.02.
  /// Default = 0.01
  final double spacingRatio;

  /// The percentage maximum value of waves. This can be used to reduce the
  /// height of bars. Default = 1;
  final double waveHeightRatio;

  /// Color of the waves to the left side of the slider button.
  final Color? waveColorPlayed;

  /// Color of the waves to the right side of the slider button.
  final Color? waveColorUnplayed;

  /// {@macro ThemeDataMerge}
  StreamVoiceRecordingSliderTheme merge(
      StreamVoiceRecordingSliderTheme? other) {
    if (other == null) return this;
    return StreamVoiceRecordingSliderTheme(
      buttonColor: other.buttonColor,
      buttonBorderColor: other.buttonBorderColor,
      buttonBorderRadius: other.buttonBorderRadius,
      horizontalPadding: other.horizontalPadding,
      spacingRatio: other.spacingRatio,
      waveHeightRatio: other.waveHeightRatio,
      waveColorPlayed: other.waveColorPlayed,
      waveColorUnplayed: other.waveColorUnplayed,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('buttonColor', buttonColor))
      ..add(ColorProperty('buttonBorderColor', buttonBorderColor))
      ..add(DiagnosticsProperty('buttonBorderRadius', buttonBorderRadius))
      ..add(DoubleProperty('horizontalPadding', horizontalPadding))
      ..add(DoubleProperty('spacingRatio', spacingRatio))
      ..add(DoubleProperty('waveHeightRatio', waveHeightRatio))
      ..add(ColorProperty('waveColorPlayed', waveColorPlayed))
      ..add(ColorProperty('waveColorUnplayed', waveColorUnplayed));
  }
}

/// {@template StreamAudioListPlayerTheme}
/// The theme data for the voice recording attachment builder audio player
/// [StreamVoiceRecordingListPlayer].
/// {@endtemplate}
@Deprecated("Use 'StreamVoiceRecordingAttachmentThemeData' instead.")
class StreamVoiceRecordingListPlayerThemeData with Diagnosticable {
  /// {@macro StreamAudioListPlayerTheme}
  const StreamVoiceRecordingListPlayerThemeData({
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.margin,
  });

  /// {@macro ThemeDataLight}
  factory StreamVoiceRecordingListPlayerThemeData.light() {
    return StreamVoiceRecordingListPlayerThemeData(
      backgroundColor: const Color(0xFFFFFFFF),
      borderColor: const Color(0xFFDBDDE1),
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.all(4),
    );
  }

  /// {@macro ThemeDataDark}
  factory StreamVoiceRecordingListPlayerThemeData.dark() {
    return StreamVoiceRecordingListPlayerThemeData(
      backgroundColor: const Color(0xFF17191C),
      borderColor: const Color(0xFF272A30),
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.all(4),
    );
  }

  /// The background color of the list.
  final Color? backgroundColor;

  /// The border color of the list.
  final Color? borderColor;

  /// The border radius of the list.
  final BorderRadius? borderRadius;

  /// The margin of the list.
  final EdgeInsets? margin;

  /// {@macro ThemeDataMerge}
  StreamVoiceRecordingListPlayerThemeData merge(
      StreamVoiceRecordingListPlayerThemeData? other) {
    if (other == null) return this;
    return StreamVoiceRecordingListPlayerThemeData(
      backgroundColor: other.backgroundColor,
      borderColor: other.borderColor,
      borderRadius: other.borderRadius,
      margin: other.margin,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('borderColor', borderColor))
      ..add(DiagnosticsProperty('borderRadius', borderRadius))
      ..add(DiagnosticsProperty('margin', margin));
  }
}

/// {@template StreamVoiceRecordingPlayerTheme}
/// The theme data for the voice recording attachment builder audio player
/// {@endtemplate}
@Deprecated("Use 'StreamVoiceRecordingAttachmentThemeData' instead.")
class StreamVoiceRecordingPlayerThemeData with Diagnosticable {
  /// {@macro StreamVoiceRecordingPlayerTheme}
  const StreamVoiceRecordingPlayerThemeData({
    this.playIcon = Icons.play_arrow,
    this.pauseIcon = Icons.pause,
    this.iconColor,
    this.buttonBackgroundColor,
    this.buttonPadding = const EdgeInsets.symmetric(horizontal: 6),
    this.buttonShape = const CircleBorder(),
    this.buttonElevation = 2,
    this.speedButtonSize = const Size(44, 36),
    this.speedButtonElevation = 2,
    this.speedButtonPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.speedButtonBackgroundColor = const Color(0xFFFFFFFF),
    this.speedButtonShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    this.speedButtonTextStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF080707),
    ),
    this.fileTypeIcon = const StreamSvgIcon(
      icon: StreamSvgIcons.filetypeAudioAac,
    ),
    this.fileSizeTextStyle = const TextStyle(fontSize: 10),
    this.timerTextStyle,
  });

  /// {@macro ThemeDataLight}
  factory StreamVoiceRecordingPlayerThemeData.light() {
    return const StreamVoiceRecordingPlayerThemeData(
      iconColor: Color(0xFF080707),
      buttonBackgroundColor: Color(0xFFFFFFFF),
    );
  }

  /// {@macro ThemeDataDark}
  factory StreamVoiceRecordingPlayerThemeData.dark() {
    return const StreamVoiceRecordingPlayerThemeData(
      iconColor: Color(0xFF080707),
      buttonBackgroundColor: Color(0xFFFFFFFF),
    );
  }

  /// The icon to display when the player is paused/stopped.
  final IconData playIcon;

  /// The icon to display when the player is playing.
  final IconData pauseIcon;

  /// The color of the icons.
  final Color? iconColor;

  /// The background color of the buttons.
  final Color? buttonBackgroundColor;

  /// The padding of the buttons.
  final EdgeInsets? buttonPadding;

  /// The shape of the buttons.
  final OutlinedBorder? buttonShape;

  /// The elevation of the buttons.
  final double? buttonElevation;

  /// The size of the speed button.
  final Size? speedButtonSize;

  /// The elevation of the speed button.
  final double? speedButtonElevation;

  /// The padding of the speed button.
  final EdgeInsets? speedButtonPadding;

  /// The background color of the speed button.
  final Color? speedButtonBackgroundColor;

  /// The shape of the speed button.
  final OutlinedBorder? speedButtonShape;

  /// The text style of the speed button.
  final TextStyle? speedButtonTextStyle;

  /// The icon to display for the file type.
  final Widget? fileTypeIcon;

  /// The text style of the file size.
  final TextStyle? fileSizeTextStyle;

  /// The text style of the timer.
  final TextStyle? timerTextStyle;

  /// {@macro ThemeDataMerge}
  StreamVoiceRecordingPlayerThemeData merge(
      StreamVoiceRecordingPlayerThemeData? other) {
    if (other == null) return this;
    return StreamVoiceRecordingPlayerThemeData(
      playIcon: other.playIcon,
      pauseIcon: other.pauseIcon,
      iconColor: other.iconColor,
      buttonBackgroundColor: other.buttonBackgroundColor,
      buttonPadding: other.buttonPadding,
      buttonShape: other.buttonShape,
      buttonElevation: other.buttonElevation,
      speedButtonSize: other.speedButtonSize,
      speedButtonElevation: other.speedButtonElevation,
      speedButtonPadding: other.speedButtonPadding,
      speedButtonBackgroundColor: other.speedButtonBackgroundColor,
      speedButtonShape: other.speedButtonShape,
      speedButtonTextStyle: other.speedButtonTextStyle,
      fileTypeIcon: other.fileTypeIcon,
      fileSizeTextStyle: other.fileSizeTextStyle,
      timerTextStyle: other.timerTextStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('playIcon', playIcon))
      ..add(DiagnosticsProperty('pauseIcon', pauseIcon))
      ..add(ColorProperty('iconColor', iconColor))
      ..add(ColorProperty('buttonBackgroundColor', buttonBackgroundColor))
      ..add(DiagnosticsProperty('buttonPadding', buttonPadding))
      ..add(DiagnosticsProperty('buttonShape', buttonShape))
      ..add(DoubleProperty('buttonElevation', buttonElevation))
      ..add(DiagnosticsProperty('speedButtonSize', speedButtonSize))
      ..add(DoubleProperty('speedButtonElevation', speedButtonElevation))
      ..add(DiagnosticsProperty('speedButtonPadding', speedButtonPadding))
      ..add(ColorProperty(
          'speedButtonBackgroundColor', speedButtonBackgroundColor))
      ..add(DiagnosticsProperty('speedButtonShape', speedButtonShape))
      ..add(DiagnosticsProperty('speedButtonTextStyle', speedButtonTextStyle))
      ..add(DiagnosticsProperty('fileTypeIcon', fileTypeIcon))
      ..add(DiagnosticsProperty('fileSizeTextStyle', fileSizeTextStyle))
      ..add(DiagnosticsProperty('timerTextStyle', timerTextStyle));
  }
}
