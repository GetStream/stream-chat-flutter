import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/media_list_view/media_list_view_controller.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template pickerWidget}
/// Allows user to select files to upload to a chat.
///
/// Should only be used on mobile - breaks on desktop & web due to the
/// permissions plugin not being supported.
/// {@endtemplate}
class PickerWidget extends StatefulWidget {
  /// {@macro pickerWidget}
  const PickerWidget({
    super.key,
    required this.mediaListViewController,
    required this.filePickerIndex,
    required this.containsFile,
    required this.selectedMedias,
    required this.onAddMoreFilesClick,
    required this.onMediaSelected,
    required this.streamChatTheme,
    this.permissionState,
  });

  /// TODO: Document me!
  final MediaListViewController mediaListViewController;

  /// TODO: Document me!
  final int filePickerIndex;

  /// TODO: Document me!
  final bool containsFile;

  final PermissionState? permissionState;

  /// The selected media to upload.
  final List<String> selectedMedias;

  /// The action to perform when adding more files.
  final void Function(DefaultAttachmentTypes) onAddMoreFilesClick;

  /// The action to perform when a media is selected.
  final void Function(AssetEntity) onMediaSelected;

  /// The theme to use for this widget.
  final StreamChatThemeData streamChatTheme;

  @override
  _PickerWidgetState createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.filePickerIndex != 0) {
      return const Offstage();
    }

    if (widget.permissionState == null) {
      return const Offstage();
    }

    if ([PermissionState.authorized, PermissionState.limited]
        .contains(widget.permissionState)) {
      if (widget.containsFile) {
        return GestureDetector(
          onTap: () {
            widget.onAddMoreFilesClick(DefaultAttachmentTypes.file);
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            color: widget.streamChatTheme.colorTheme.inputBg,
            alignment: Alignment.center,
            child: Text(
              context.translations.addMoreFilesLabel,
              style: TextStyle(
                color: widget.streamChatTheme.colorTheme.accentPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return StreamMediaListView(
        selectedIds: widget.selectedMedias,
        onSelect: widget.onMediaSelected,
      );
    }

    return InkWell(
      onTap: () async => PhotoManager.openSetting(),
      child: ColoredBox(
        color: widget.streamChatTheme.colorTheme.inputBg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'svgs/icon_picture_empty_state.svg',
              package: 'stream_chat_flutter',
              height: 140,
              color: widget.streamChatTheme.colorTheme.disabled,
            ),
            Text(
              context.translations.enablePhotoAndVideoAccessMessage,
              style: widget.streamChatTheme.textTheme.body.copyWith(
                color: widget.streamChatTheme.colorTheme.textLowEmphasis,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                context.translations.allowGalleryAccessMessage,
                style: widget.streamChatTheme.textTheme.bodyBold.copyWith(
                  color: widget.streamChatTheme.colorTheme.accentPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
