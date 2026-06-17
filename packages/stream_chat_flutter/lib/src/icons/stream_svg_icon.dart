import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart';

part 'stream_svg_icon.g.dart';

/// {@template StreamSvgIconData}
/// A class that holds the data for a [StreamSvgIcon].
/// {@endtemplate}
@Deprecated('Will be removed in the next major version')
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
  /// Icon(context.streamIcons.arrowRight)
  /// ```
  ///
  /// List of replacement icons:
  ///
  /// - StreamSvgIcons.arrowRight -> context.streamIcons.arrowRight
  /// - StreamSvgIcons.attach -> context.streamIcons.attachment
  /// - StreamSvgIcons.award -> context.streamIcons.trophy
  /// - StreamSvgIcons.camera -> context.streamIcons.camera
  /// - StreamSvgIcons.check -> context.streamIcons.checkmark
  /// - StreamSvgIcons.checkAll -> context.streamIcons.checks
  /// - StreamSvgIcons.checkSend -> context.streamIcons.checkmark
  /// - StreamSvgIcons.circleUp -> context.streamIcons.arrowUp
  /// - StreamSvgIcons.close -> context.streamIcons.xmark
  /// - StreamSvgIcons.closeSmall -> context.streamIcons.xmark
  /// - StreamSvgIcons.contacts -> context.streamIcons.users
  /// - StreamSvgIcons.copy -> context.streamIcons.copy
  /// - StreamSvgIcons.delete -> context.streamIcons.delete
  /// - StreamSvgIcons.down -> context.streamIcons.chevronDown
  /// - StreamSvgIcons.download -> context.streamIcons.download
  /// - StreamSvgIcons.edit -> context.streamIcons.edit
  /// - StreamSvgIcons.emptyCircleRight -> context.streamIcons.chevronRight
  /// - StreamSvgIcons.error -> context.streamIcons.exclamationCircleFill
  /// - StreamSvgIcons.eye -> context.streamIcons.eyeFill
  /// - StreamSvgIcons.files -> context.streamIcons.file
  /// - StreamSvgIcons.flag -> context.streamIcons.flag
  /// - StreamSvgIcons.grid -> context.streamIcons.gallery
  /// - StreamSvgIcons.group -> context.streamIcons.users
  /// - StreamSvgIcons.left -> context.streamIcons.chevronLeft
  /// - StreamSvgIcons.lightning -> context.streamIcons.bolt
  /// - StreamSvgIcons.link -> context.streamIcons.link
  /// - StreamSvgIcons.lock -> context.streamIcons.lock
  /// - StreamSvgIcons.mentions -> context.streamIcons.mention
  /// - StreamSvgIcons.menuPoint -> context.streamIcons.more
  /// - StreamSvgIcons.message -> context.streamIcons.messageBubble
  /// - StreamSvgIcons.messageUnread -> context.streamIcons.notification
  /// - StreamSvgIcons.mic -> context.streamIcons.voice
  /// - StreamSvgIcons.mute -> context.streamIcons.mute
  /// - StreamSvgIcons.notification -> context.streamIcons.bell
  /// - StreamSvgIcons.pause -> context.streamIcons.pauseFill
  /// - StreamSvgIcons.penWrite -> context.streamIcons.edit
  /// - StreamSvgIcons.pictures -> context.streamIcons.image
  /// - StreamSvgIcons.pin -> context.streamIcons.pin
  /// - StreamSvgIcons.play -> context.streamIcons.playFill
  /// - StreamSvgIcons.polls -> context.streamIcons.poll
  /// - StreamSvgIcons.record -> context.streamIcons.video
  /// - StreamSvgIcons.reload -> context.streamIcons.refresh
  /// - StreamSvgIcons.reply -> context.streamIcons.reply
  /// - StreamSvgIcons.retry -> context.streamIcons.retry
  /// - StreamSvgIcons.right -> context.streamIcons.chevronRight
  /// - StreamSvgIcons.save -> context.streamIcons.save
  /// - StreamSvgIcons.search -> context.streamIcons.search
  /// - StreamSvgIcons.send -> context.streamIcons.send
  /// - StreamSvgIcons.sendMessage -> context.streamIcons.send
  /// - StreamSvgIcons.share -> context.streamIcons.export
  /// - StreamSvgIcons.shareArrow -> context.streamIcons.share
  /// - StreamSvgIcons.smile -> context.streamIcons.emoji
  /// - StreamSvgIcons.stop -> context.streamIcons.stopFill
  /// - StreamSvgIcons.threadReply -> context.streamIcons.thread
  /// - StreamSvgIcons.time -> context.streamIcons.clock
  /// - StreamSvgIcons.up -> context.streamIcons.chevronUp
  /// - StreamSvgIcons.user -> context.streamIcons.user
  /// - StreamSvgIcons.userAdd -> context.streamIcons.userAdd
  /// - StreamSvgIcons.userDelete -> context.streamIcons.userRemove
  /// - StreamSvgIcons.userRemove -> context.streamIcons.userRemove
  /// - StreamSvgIcons.userSettings -> context.streamIcons.userCheck
  /// - StreamSvgIcons.videoCall -> context.streamIcons.videoFill
  /// - StreamSvgIcons.volumeUp -> context.streamIcons.audio
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
