import 'package:flutter/material.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

part 'stream_svg_icon.g.dart';

/// {@template StreamSvgIconData}
/// A class that holds the data for a [StreamSvgIcon].
/// {@endtemplate}
typedef StreamSvgIconData = SvgIconData;

/// {@template StreamSvgIcon}
/// Icon set of stream chat
/// {@endtemplate}
@Deprecated('Use Icon(context.streamIcons.*) instead')
class StreamSvgIcon extends StatelessWidget {
  /// Creates a [StreamSvgIcon].
  ///
  /// Deprecated in favor of regular [Icon] widgets.
  /// New icons can be replaced using the [StreamIcons] theme data.
  ///
  /// Previously:
  ///
  /// ```dart
  /// StreamSvgIcon(icon: StreamSvgIcons.arrowRight)
  /// ```
  ///
  /// Replacement:
  ///
  /// ```dart
  /// Icon(context.streamIcons.arrowRight20)
  /// ```
  ///
  /// List of replacement icons:
  ///
  /// - StreamSvgIcons.arrowRight -> context.streamIcons.arrowRight20
  /// - StreamSvgIcons.attach -> context.streamIcons.attachment20
  /// - StreamSvgIcons.award -> context.streamIcons.trophy20
  /// - StreamSvgIcons.camera -> context.streamIcons.camera20
  /// - StreamSvgIcons.check -> context.streamIcons.checkmark20
  /// - StreamSvgIcons.checkAll -> context.streamIcons.checks20
  /// - StreamSvgIcons.checkSend -> context.streamIcons.checkmark20
  /// - StreamSvgIcons.circleUp -> context.streamIcons.arrowUp20
  /// - StreamSvgIcons.close -> context.streamIcons.xmark20
  /// - StreamSvgIcons.closeSmall -> context.streamIcons.xmark16
  /// - StreamSvgIcons.contacts -> context.streamIcons.users20
  /// - StreamSvgIcons.copy -> context.streamIcons.copy20
  /// - StreamSvgIcons.delete -> context.streamIcons.delete20
  /// - StreamSvgIcons.down -> context.streamIcons.chevronDown20
  /// - StreamSvgIcons.download -> context.streamIcons.download20
  /// - StreamSvgIcons.edit -> context.streamIcons.edit20
  /// - StreamSvgIcons.emptyCircleRight -> context.streamIcons.chevronRight20
  /// - StreamSvgIcons.error -> context.streamIcons.exclamationCircleFill20
  /// - StreamSvgIcons.eye -> context.streamIcons.eyeFill20
  /// - StreamSvgIcons.files -> context.streamIcons.file20
  /// - StreamSvgIcons.flag -> context.streamIcons.flag20
  /// - StreamSvgIcons.grid -> context.streamIcons.gallery20
  /// - StreamSvgIcons.group -> context.streamIcons.users20
  /// - StreamSvgIcons.left -> context.streamIcons.chevronLeft20
  /// - StreamSvgIcons.lightning -> context.streamIcons.bolt20
  /// - StreamSvgIcons.link -> context.streamIcons.link20
  /// - StreamSvgIcons.lock -> context.streamIcons.lock20
  /// - StreamSvgIcons.mentions -> context.streamIcons.mention20
  /// - StreamSvgIcons.menuPoint -> context.streamIcons.more20
  /// - StreamSvgIcons.message -> context.streamIcons.messageBubble20
  /// - StreamSvgIcons.messageUnread -> context.streamIcons.notification20
  /// - StreamSvgIcons.mic -> context.streamIcons.voice20
  /// - StreamSvgIcons.mute -> context.streamIcons.mute20
  /// - StreamSvgIcons.notification -> context.streamIcons.bell20
  /// - StreamSvgIcons.pause -> context.streamIcons.pauseFill20
  /// - StreamSvgIcons.penWrite -> context.streamIcons.edit20
  /// - StreamSvgIcons.pictures -> context.streamIcons.image20
  /// - StreamSvgIcons.pin -> context.streamIcons.pin20
  /// - StreamSvgIcons.play -> context.streamIcons.playFill20
  /// - StreamSvgIcons.polls -> context.streamIcons.poll20
  /// - StreamSvgIcons.record -> context.streamIcons.video20
  /// - StreamSvgIcons.reload -> context.streamIcons.refresh20
  /// - StreamSvgIcons.reply -> context.streamIcons.reply20
  /// - StreamSvgIcons.retry -> context.streamIcons.retry20
  /// - StreamSvgIcons.right -> context.streamIcons.chevronRight20
  /// - StreamSvgIcons.save -> context.streamIcons.save20
  /// - StreamSvgIcons.search -> context.streamIcons.search20
  /// - StreamSvgIcons.send -> context.streamIcons.send20
  /// - StreamSvgIcons.sendMessage -> context.streamIcons.send20
  /// - StreamSvgIcons.share -> context.streamIcons.export20
  /// - StreamSvgIcons.shareArrow -> context.streamIcons.share20
  /// - StreamSvgIcons.smile -> context.streamIcons.emoji20
  /// - StreamSvgIcons.stop -> context.streamIcons.stopFill20
  /// - StreamSvgIcons.threadReply -> context.streamIcons.thread20
  /// - StreamSvgIcons.time -> context.streamIcons.clock20
  /// - StreamSvgIcons.up -> context.streamIcons.chevronUp20
  /// - StreamSvgIcons.user -> context.streamIcons.user20
  /// - StreamSvgIcons.userAdd -> context.streamIcons.userAdd20
  /// - StreamSvgIcons.userDelete -> context.streamIcons.userRemove20
  /// - StreamSvgIcons.userRemove -> context.streamIcons.userRemove20
  /// - StreamSvgIcons.userSettings -> context.streamIcons.userCheck20
  /// - StreamSvgIcons.videoCall -> context.streamIcons.videoFill20
  /// - StreamSvgIcons.volumeUp -> context.streamIcons.audio20
  ///
  /// Removed in new set (no equivalent):
  /// - StreamSvgIcons.cloudDownload
  /// - StreamSvgIcons.lolReaction
  /// - StreamSvgIcons.loveReaction
  /// - StreamSvgIcons.moon
  /// - StreamSvgIcons.settings
  /// - StreamSvgIcons.thumbsDownReaction
  /// - StreamSvgIcons.thumbsUpReaction
  /// - StreamSvgIcons.wutReaction
  @Deprecated('Use Icon(context.streamIcons.*) instead')
  const StreamSvgIcon({
    super.key,
    this.icon,
    this.color,
    this.size,
    this.textDirection,
    this.semanticLabel,
    this.applyTextScaling,
  });

  /// The icon to display.
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final StreamSvgIconData? icon;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.size].
  ///
  /// If this [Icon] is being placed inside an [IconButton], then use
  /// [IconButton.iconSize] instead, so that the [IconButton] can make the
  /// splash area the appropriate size as well. The [IconButton] uses an
  /// [IconTheme] to pass down the size to the [Icon].
  final double? size;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.color].
  ///
  /// The color (whether specified explicitly here or obtained from the
  /// [IconTheme]) will be further adjusted by the nearest [IconTheme]'s
  /// [IconThemeData.opacity].
  ///
  /// {@tool snippet}
  /// Typically, a Material Design color will be used, as follows:
  ///
  /// ```dart
  /// StreamSvgIcon(
  ///   icon: 'reload.svg',
  ///   color: Colors.blue.shade400,
  /// )
  /// ```
  /// {@end-tool}
  final Color? color;

  /// The text direction to use for rendering the icon.
  ///
  /// If this is null, the ambient [Directionality] is used instead.
  ///
  /// Some icons follow the reading direction. For example, "back" buttons point
  /// left in left-to-right environments and right in right-to-left
  /// environments. Such icons have their [SvgIconData.matchTextDirection] field
  /// set to true, and the [SvgIcon] widget uses the [textDirection] to
  /// determine the orientation in which to draw the icon.
  ///
  /// This property has no effect if the [icon]'s
  /// [SvgIconData.matchTextDirection] field is false, but for consistency a
  /// text direction value must always be specified, either directly using this
  /// property or using [Directionality].
  final TextDirection? textDirection;

  /// Whether to scale the size of this widget using the ambient [MediaQuery]'s
  /// [TextScaler].
  ///
  /// This is specially useful when you have an icon associated with a text, as
  /// scaling the text without scaling the icon would result in a confusing
  /// interface.
  ///
  /// Defaults to the nearest [IconTheme]'s
  /// [IconThemeData.applyTextScaling].
  final bool? applyTextScaling;

  /// Semantic label for the icon.
  ///
  /// Announced by assistive technologies (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  ///
  ///  * [SemanticsProperties.label], which is set to [semanticLabel] in the
  ///    underlying	 [Semantics] widget.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgIcon(
      icon,
      size: size,
      color: color,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      semanticLabel: semanticLabel,
    );
  }
}
