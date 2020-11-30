import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreamSvgIcon extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final Color color;

  const StreamSvgIcon({
    this.assetName,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final key = Key('StreamSvgIcon-$assetName');
    return kIsWeb
        ? Image.network(
            'packages/stream_chat_flutter/svgs/$assetName',
            width: width,
            height: height,
            key: key,
            color: color,
            alignment: Alignment.center,
          )
        : SvgPicture.asset(
            'lib/svgs/$assetName',
            package: 'stream_chat_flutter',
            key: key,
            width: width,
            height: height,
            color: color,
            alignment: Alignment.center,
          );
  }

  factory StreamSvgIcon.settings({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'settings.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.down({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_down.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.attach({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_attach.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.smile({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_smile.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.mentions({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'mentions.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.record({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_record.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.camera({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_camera.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.files({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'files.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.pictures({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'pictures.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.left({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_left.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.user({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_user.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.userAdd({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_User_add.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.check({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_check.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.penWrite({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_pen-write.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.contacts({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_contacts.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.close({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_close.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.search({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_search.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.right({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_right.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.mute({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_mute.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.userRemove({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_User_deselect.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.lightning({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_lightning-command runner.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.emptyCircleLeft({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_empty_circle_left.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.message({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_message.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.thread({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_Thread_Reply.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.edit({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_edit.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.copy({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_copy.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.delete({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_delete.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.eye({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_eye-off.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.arrow_right({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_arrow_right.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.close_small({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_close_sml.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.Icon_curve_line_left_up({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_curve_line_left_up.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.icon_SHARE({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'icon_SHARE.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.Icon_grid({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_grid.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.Icon_send_message({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_send_message.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.Icon_menu_point_v({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_menu_point_v.svg',
      color: color,
      width: size,
      height: size,
    );
  }

  factory StreamSvgIcon.Icon_save({
    double size,
    Color color,
  }) {
    return StreamSvgIcon(
      assetName: 'Icon_save.svg',
      color: color,
      width: size,
      height: size,
    );
  }
}
