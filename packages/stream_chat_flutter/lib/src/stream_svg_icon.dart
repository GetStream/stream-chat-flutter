import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreamSvgIcon extends StatelessWidget {
  final String? assetName;
  final double? width;
  final double? height;
  final Color? color;

  const StreamSvgIcon({
    this.assetName,
    this.color,
    this.width = 24,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    final key = Key('StreamSvgIcon-$assetName');
    return SvgPicture.asset(
      'lib/svgs/$assetName',
      package: 'stream_chat_flutter',
      key: key,
      width: width,
      height: height,
      color: color,
    );
  }

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
}
