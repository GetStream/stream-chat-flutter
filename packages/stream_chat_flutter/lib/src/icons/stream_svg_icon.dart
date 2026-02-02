// ignore_for_file: deprecated_member_use_from_same_package

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
class StreamSvgIcon extends StatelessWidget {
  /// Creates a [StreamSvgIcon].
  const StreamSvgIcon({
    super.key,
    this.icon,
    @Deprecated("Use 'icon' instead") this.assetName,
    this.color,
    double? size,
    @Deprecated("Use 'size' instead") this.width,
    @Deprecated("Use 'size' instead") this.height,
    this.textDirection,
    this.semanticLabel,
    this.applyTextScaling,
  })  : assert(
          size == null || (width == null && height == null),
          'Cannot provide both a size and a width or height',
        ),
        size = size ?? width ?? height;

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.settings({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.settings,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.down({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.down,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.up({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.up,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.attach({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.attach,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.loveReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.loveReaction,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.thumbsUpReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.thumbsUpReaction,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.thumbsDownReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.thumbsDownReaction,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.lolReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.lolReaction,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.wutReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.wutReaction,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.smile({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.smile,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.mentions({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.mentions,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.record({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.record,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.camera({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.camera,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.files({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.files,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.polls({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.polls,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.send({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.send,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.pictures({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.pictures,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.left({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.left,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.user({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.user,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.userAdd({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.userAdd,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.check({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.check,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.checkAll({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.checkAll,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.checkSend({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.checkSend,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.penWrite({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.penWrite,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.contacts({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.contacts,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.close({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.close,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.search({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.search,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.right({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.right,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.mute({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.mute,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.userRemove({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.userRemove,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.lightning({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.lightning,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.emptyCircleLeft({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.emptyCircleRight,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.message({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.message,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.messageUnread({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.messageUnread,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.thread({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.threadReply,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.reply({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.reply,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.edit({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.edit,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.download({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.download,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.cloudDownload({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.cloudDownload,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.copy({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.copy,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.delete({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.delete,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.eye({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.eye,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.arrowRight({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.arrowRight,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.closeSmall({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.closeSmall,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconCurveLineLeftUp({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.reply,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconMoon({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.moon,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconShare({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.share,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconGrid({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.grid,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconSendMessage({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.sendMessage,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconMenuPoint({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.menuPoint,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconSave({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.save,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.shareArrow({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.shareArrow,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeAac({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeAudioAac,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetype7z({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCompression7z,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeCsv({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCodeCsv,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeDoc({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeTextDoc,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeDocx({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeTextDocx,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeGeneric({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeOtherStandard,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeHtml({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCodeHtml,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeMd({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCodeMd,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeOdt({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeTextOdt,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypePdf({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeOtherPdf,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypePpt({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypePresentationPpt,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypePptx({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypePresentationPptx,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeRar({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCompressionRar,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeRtf({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeTextRtf,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeTar({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCodeTar,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeTxt({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeTextTxt,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeXls({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeSpreadsheetXls,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeXlsx({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeSpreadsheetXlsx,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.filetypeZip({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.filetypeCompressionZip,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconGroup({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.group,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconNotification({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.notification,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconUserDelete({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.userDelete,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.error({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.error,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.circleUp({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.circleUp,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconUserSettings({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.userSettings,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.giphyIcon({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.giphy,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.imgur({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.imgur,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.volumeUp({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.volumeUp,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.flag({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.flag,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.iconFlag({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.flag,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.retry({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.retry,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.pin({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.pin,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.videoCall({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.videoCall,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.award({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.award,
      color: color,
      size: size,
    );
  }

  /// [StreamSvgIcon] type
  @Deprecated("Use regular 'StreamSvgIcon' with 'icon' instead")
  factory StreamSvgIcon.reload({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      icon: StreamSvgIcons.reload,
      color: color,
      size: size,
    );
  }

  /// The icon to display.
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final StreamSvgIconData? icon;

  /// The asset to display.
  ///
  /// The asset can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  @Deprecated("Use 'icon' instead")
  final String? assetName;

  /// Width of icon
  @Deprecated("Use 'size' instead")
  final double? width;

  /// Height of icon
  @Deprecated("Use 'size' instead")
  final double? height;

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
    assert(
      icon == null || assetName == null,
      'Cannot provide both an icon and an assetName',
    );

    const iconPackage = 'stream_chat_flutter';
    final iconData = switch (icon) {
      final icon? => icon,
      null => switch (assetName) {
          final name? => SvgIconData(
              'lib/svgs/$name',
              package: iconPackage,
            ),
          _ => null,
        },
    };

    return SvgIcon(
      iconData,
      size: size,
      color: color,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      semanticLabel: semanticLabel,
    );
  }
}

/// Alternative of [StreamSvgIcon] which follows the [IconTheme].
@Deprecated("Use regular 'StreamSvgIcon' instead")
class StreamIconThemeSvgIcon extends StatelessWidget {
  /// Creates a [StreamIconThemeSvgIcon].
  @Deprecated("Use regular 'StreamSvgIcon' instead")
  const StreamIconThemeSvgIcon({
    super.key,
    this.assetName,
    this.width,
    this.height,
    this.color,
  });

  /// Factory constructor to create [StreamIconThemeSvgIcon]
  /// from [StreamSvgIcon].
  @Deprecated("Use regular 'StreamSvgIcon' instead")
  factory StreamIconThemeSvgIcon.fromSvgIcon(
    StreamSvgIcon streamSvgIcon,
  ) {
    return StreamIconThemeSvgIcon(
      assetName: streamSvgIcon.assetName,
      width: streamSvgIcon.width,
      height: streamSvgIcon.height,
      color: streamSvgIcon.color,
    );
  }

  /// Name of icon asset
  final String? assetName;

  /// Width of icon
  final double? width;

  /// Height of icon
  final double? height;

  /// Color of icon
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final color = this.color ?? iconTheme.color;
    final width = this.width ?? iconTheme.size;
    final height = this.height ?? iconTheme.size;

    return StreamSvgIcon(
      assetName: assetName,
      width: width,
      height: height,
      color: color,
    );
  }
}
