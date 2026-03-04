import 'package:flutter/material.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';

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
  /// Replacement icons:
  ///
  /// Exact / close matches:
  /// - StreamSvgIcons.arrowRight -> context.streamIcons.arrowRight
  /// - StreamSvgIcons.attach -> context.streamIcons.paperclip1
  /// - StreamSvgIcons.camera -> context.streamIcons.camera1
  /// - StreamSvgIcons.check -> context.streamIcons.checkmark2
  /// - StreamSvgIcons.checkAll -> context.streamIcons.doupleCheckmark1Small
  /// - StreamSvgIcons.checkSend -> context.streamIcons.circleCheck
  /// - StreamSvgIcons.close -> context.streamIcons.crossMedium
  /// - StreamSvgIcons.closeSmall -> context.streamIcons.crossSmall
  /// - StreamSvgIcons.copy -> context.streamIcons.squareBehindSquare2Copy
  /// - StreamSvgIcons.delete -> context.streamIcons.trashBin
  /// - StreamSvgIcons.down -> context.streamIcons.chevronDown
  /// - StreamSvgIcons.edit -> context.streamIcons.editBig
  /// - StreamSvgIcons.error -> context.streamIcons.exclamationCircle1
  /// - StreamSvgIcons.eye -> context.streamIcons.eyeOpen
  /// - StreamSvgIcons.flag -> context.streamIcons.flag2
  /// - StreamSvgIcons.left -> context.streamIcons.chevronLeft
  /// - StreamSvgIcons.lightning -> context.streamIcons.thunder
  /// - StreamSvgIcons.link -> context.streamIcons.chainLink3
  /// - StreamSvgIcons.lock -> context.streamIcons.lock
  /// - StreamSvgIcons.mentions -> context.streamIcons.at
  /// - StreamSvgIcons.mic -> context.streamIcons.microphone
  /// - StreamSvgIcons.mute -> context.streamIcons.mute
  /// - StreamSvgIcons.notification -> context.streamIcons.bellNotification
  /// - StreamSvgIcons.pause -> context.streamIcons.pause
  /// - StreamSvgIcons.penWrite -> context.streamIcons.pencil
  /// - StreamSvgIcons.pin -> context.streamIcons.pin
  /// - StreamSvgIcons.right -> context.streamIcons.chevronRight
  /// - StreamSvgIcons.search -> context.streamIcons.magnifyingGlassSearch
  /// - StreamSvgIcons.settings -> context.streamIcons.settingsGear2
  /// - StreamSvgIcons.smile -> context.streamIcons.emojiSmile
  /// - StreamSvgIcons.stop -> context.streamIcons.stop
  /// - StreamSvgIcons.time -> context.streamIcons.clock
  /// - StreamSvgIcons.up -> context.streamIcons.chevronTop
  /// - StreamSvgIcons.volumeUp -> context.streamIcons.volumeFull
  ///
  /// Conceptual matches (similar purpose, may differ visually):
  /// - StreamSvgIcons.award -> context.streamIcons.trophy
  /// - StreamSvgIcons.circleUp -> context.streamIcons.arrowUp (no circle)
  /// - StreamSvgIcons.contacts -> context.streamIcons.users
  /// - StreamSvgIcons.download -> context.streamIcons.arrowDown (no tray)
  /// - StreamSvgIcons.emptyCircleRight -> context.streamIcons.chevronRight (no circle)
  /// - StreamSvgIcons.files -> context.streamIcons.fileBend (folder vs document)
  /// - StreamSvgIcons.grid -> context.streamIcons.layoutGrid1 (3x3 vs 2x2)
  /// - StreamSvgIcons.group -> context.streamIcons.users
  /// - StreamSvgIcons.loveReaction -> context.streamIcons.heart2
  /// - StreamSvgIcons.menuPoint -> context.streamIcons.dotsGrid1x3Vertical
  /// - StreamSvgIcons.message -> context.streamIcons.bubble3ChatMessage
  /// - StreamSvgIcons.messageUnread -> context.streamIcons.bubbleWideNotificationChatMessage
  /// - StreamSvgIcons.pictures -> context.streamIcons.images1Alt
  /// - StreamSvgIcons.play -> context.streamIcons.playSolid
  /// - StreamSvgIcons.polls -> context.streamIcons.chart5
  /// - StreamSvgIcons.record -> context.streamIcons.video
  /// - StreamSvgIcons.reload -> context.streamIcons.arrowRotateRightLeftRepeatRefresh
  /// - StreamSvgIcons.reply -> context.streamIcons.arrowShareLeft
  /// - StreamSvgIcons.retry -> context.streamIcons.arrowRotateClockwise
  /// - StreamSvgIcons.save -> context.streamIcons.bookmark (arrow vs ribbon)
  /// - StreamSvgIcons.send -> context.streamIcons.paperPlane
  /// - StreamSvgIcons.sendMessage -> context.streamIcons.paperPlaneTopRight (no circle)
  /// - StreamSvgIcons.share -> context.streamIcons.shareOs
  /// - StreamSvgIcons.shareArrow -> context.streamIcons.shareRedirectLink
  /// - StreamSvgIcons.threadReply -> context.streamIcons.bubbleAnnotation2ChatMessage
  /// - StreamSvgIcons.user -> context.streamIcons.people
  /// - StreamSvgIcons.userAdd -> context.streamIcons.peopleAdd
  /// - StreamSvgIcons.userDelete -> context.streamIcons.peopleRemove
  /// - StreamSvgIcons.userRemove -> context.streamIcons.peopleRemove
  /// - StreamSvgIcons.userSettings -> context.streamIcons.peopleEditUserRights
  /// - StreamSvgIcons.videoCall -> context.streamIcons.videoSolid
  ///
  /// Removed in new set (no equivalent):
  /// - StreamSvgIcons.cloudDownload
  /// - StreamSvgIcons.lolReaction
  /// - StreamSvgIcons.moon
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
