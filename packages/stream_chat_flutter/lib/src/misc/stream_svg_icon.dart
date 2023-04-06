import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// {@template streamSvgIcon}
/// Icon set of stream chat
/// {@endtemplate}
class StreamSvgIcon extends StatelessWidget {
  /// {@macro streamSvgIcon}
  const StreamSvgIcon({
    super.key,
    this.assetName,
    this.color,
    this.width,
    this.height,
  });

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.settings({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'settings.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.down({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_down.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.up({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_up.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.attach({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_attach.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.loveReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_love_reaction.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.thumbsUpReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_thumbs_up_reaction.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.thumbsDownReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_thumbs_down_reaction.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.lolReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_LOL_reaction.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.wutReaction({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_wut_reaction.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.smile({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_smile.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.mentions({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'mentions.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.record({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_record.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.camera({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_camera.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.files({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'files.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.pictures({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'pictures.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.left({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_left.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.user({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_user.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.userAdd({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_User_add.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.check({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_check.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.checkAll({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_check_all.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.checkSend({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_check_send.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.penWrite({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_pen-write.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.contacts({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_contacts.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.close({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_close.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.search({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_search.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.right({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_right.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.mute({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_mute.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.userRemove({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_User_deselect.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.lightning({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_lightning-command runner.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.emptyCircleLeft({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_empty_circle_left.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.message({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_message.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.thread({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_Thread_Reply.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.reply({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_curve_line_left_up_big.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.edit({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_edit.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.download({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_download.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.cloudDownload({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_cloud_download.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.copy({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_copy.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.delete({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_delete.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.eye({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_eye-off.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.arrowRight({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_arrow_right.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.closeSmall({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_close_sml.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconCurveLineLeftUp({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_curve_line_left_up.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconMoon({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'icon_moon.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconShare({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'icon_SHARE.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconGrid({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_grid.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconSendMessage({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_send_message.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconMenuPoint({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_menu_point_v.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconSave({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_save.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.shareArrow({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'share_arrow.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetype7z({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_7z.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeCsv({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_CSV.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeDoc({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_DOC.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeDocx({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_DOCX.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeGeneric({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_Generic.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeHtml({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_html.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeMd({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_MD.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeOdt({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_ODT.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypePdf({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_PDF.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypePpt({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_PPT.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypePptx({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_PPTX.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeRar({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_RAR.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeRtf({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_RTF.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeTar({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_TAR.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeTxt({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_TXT.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeXls({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_XLS.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeXlsx({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_XLSX.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.filetypeZip({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'filetype_ZIP.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconGroup({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_group.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconNotification({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_notification.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconUserDelete({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_user_delete.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.error({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_error.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.circleUp({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_circle_up.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconUserSettings({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_user_settings.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.giphyIcon({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'giphy_icon.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.imgur({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'imgur.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.volumeUp({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'volume-up.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.flag({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'flag.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.iconFlag({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'icon_flag.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.retry({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'icon_retry.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.pin({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'icon_pin.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  /// [StreamSvgIcon] type
  factory StreamSvgIcon.videoCall({
    double? size,
    Color? color,
  }) {
    return StreamSvgIcon(
      assetName: 'video_call_icon.svg',
      color: color,
      width: size,
      height: size,
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
    final key = Key('StreamSvgIcon-$assetName');
    return SvgPicture.asset(
      'lib/svgs/$assetName',
      package: 'stream_chat_flutter',
      key: key,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            )
          : null,
    );
  }
}

/// Alternative of [StreamSvgIcon] which follows the [IconTheme].
class StreamIconThemeSvgIcon extends StatelessWidget {
  /// Creates a [StreamIconThemeSvgIcon].
  const StreamIconThemeSvgIcon({
    super.key,
    this.assetName,
    this.width,
    this.height,
    this.color,
  });

  /// Factory constructor to create [StreamIconThemeSvgIcon]
  /// from [StreamSvgIcon].
  factory StreamIconThemeSvgIcon.fromStreamSvgIcon(
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
