import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showEditGroupSheet}
/// Displays the group-edit bottom sheet for [channel] — Figma frame
/// `8833:446261`. Resolves to `true` if the user saved a change, otherwise
/// `false` / `null` on dismiss.
/// {@endtemplate}
Future<bool?> showEditGroupSheet(BuildContext context, Channel channel) {
  return showStreamSheet<bool>(
    context: context,
    isDismissible: true,
    builder: (_, _) => StreamChannel(
      channel: channel,
      child: const EditGroupSheet(),
    ),
  );
}

/// {@template editGroupSheet}
/// A bottom sheet that lets the current user rename the channel and replace
/// (or reset) the channel avatar.
///
/// The avatar tap (or _Upload_ link) opens [_AvatarPickerSheet], which
/// surfaces _Take Photo_, _Choose Image_, and _Reset Picture_ as the
/// three quick actions. Picked images are uploaded immediately via
/// [StreamChatClient.sendImage] so the URL is settled by the time the user
/// taps the save checkmark.
/// {@endtemplate}
class EditGroupSheet extends StatefulWidget {
  /// {@macro editGroupSheet}
  const EditGroupSheet({super.key});

  @override
  State<EditGroupSheet> createState() => _EditGroupSheetState();
}

class _EditGroupSheetState extends State<EditGroupSheet> {
  late final Channel _channel = StreamChannel.of(context).channel;
  late final TextEditingController _nameController = TextEditingController(
    text: _channel.name ?? '',
  );

  bool _saving = false;

  // Determinate upload progress in [0, 1], or `null` when no upload is in
  // flight. Drives the spinner overlay on the avatar preview only — image
  // state itself flows through `channel.imageStream` (we save eagerly on
  // pick / reset).
  double? _uploadProgress;

  String get _name => _nameController.text.trim();
  String get _initialName => (_channel.extraData['name'] as String?) ?? '';

  // Save is only for the channel name — image changes are persisted
  // eagerly via channel.updateImage / updatePartial. Gated on a non-empty
  // name (the API won't accept blanks), no in-flight save, and no
  // in-flight upload.
  bool get _canSave => _name != _initialName && _name.isNotEmpty && !_saving && _uploadProgress == null;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    // The sheet route consumes the top inset via its own SafeArea, but
    // intentionally leaves the bottom inset so descendants can opt in.
    // The keyboard inset arrives via viewInsets — pad the body's bottom
    // by it so the text input never disappears behind the keyboard.
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return SafeArea(
      top: false,
      child: Column(
        // Shrink-wrap to content height — the sheet sits as high as it
        // needs to be (header + avatar + input + keyboard inset) and no
        // higher. With Stack(StackFit.loose) upstream the StreamSheet
        // honours the min size and rests just above the keyboard.
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamSheetHeader(
            title: const Text('Edit'),
            // Default `.medium` size — matches the auto-implied close
            // button on the leading side so the header stays balanced.
            trailing: StreamButton.icon(
              icon: Icon(context.streamIcons.checkmark),
              type: .solid,
              onPressed: _canSave ? _save : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: spacing.md,
              right: spacing.md,
              top: spacing.md,
              bottom: spacing.md + viewInsets.bottom,
            ),
            child: Column(
              children: [
                _AvatarPreview(
                  uploadProgress: _uploadProgress,
                  onTap: _openAvatarPicker,
                ),
                SizedBox(height: spacing.md),
                StreamTextInput(
                  controller: _nameController,
                  autofocus: true,
                  hintText: 'Group name',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAvatarPicker() async {
    final action = await _showAvatarPickerSheet(context);
    if (action == null || !mounted) return;
    switch (action) {
      case _AvatarPickerAction.takePhoto:
        await _pickAndUpload(ImageSource.camera);
      case _AvatarPickerAction.chooseImage:
        await _pickAndUpload(ImageSource.gallery);
      case _AvatarPickerAction.resetPicture:
        await _resetPicture();
    }
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null || !mounted) return;

    final file = File(picked.path);
    final size = await file.length();
    final attachmentFile = AttachmentFile(
      path: picked.path,
      size: size,
      name: picked.name,
    );

    // Start with `0` so the spinner shows up immediately as a determinate
    // bar at 0%; the first onSendProgress callback may not arrive for a
    // few hundred ms on slow networks.
    setState(() => _uploadProgress = 0);
    try {
      final client = StreamChat.of(context).client;
      // Standalone upload — returns a CDN URL we can persist on the
      // channel without creating a message.
      final response = await client.sendImage(
        attachmentFile,
        _channel.id!,
        _channel.type,
        onSendProgress: (count, total) {
          if (!mounted) return;
          // Fall back to indeterminate (`null`) when the server doesn't
          // report a content length — prevents the spinner from claiming
          // a fake 0% for the entire upload.
          setState(() {
            _uploadProgress = total > 0 ? count / total : null;
          });
        },
      );
      final url = response.file;
      if (url == null) return;
      // Eagerly persist — channel.imageStream emits the new URL,
      // StreamChannelAvatar (in this sheet and across the app) reloads
      // automatically via its BetterStreamBuilder.
      await _channel.updateImage(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadProgress = null);
    }
  }

  Future<void> _resetPicture() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Eager unset — channel.imageStream emits `null`, the channel
      // avatar reverts to the member-group fallback automatically.
      await _channel.updatePartial(unset: ['image']);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Failed to reset: $e')));
    }
  }

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      // Image changes are already persisted eagerly — save handles only
      // the deferred name edit, which we batch through the rest of the
      // typing session via the controller listener.
      await _channel.updateName(_name);
      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      if (mounted) setState(() => _saving = false);
    }
  }
}

/// The hero avatar block — reactive [StreamChannelAvatar] (it reloads
/// automatically off [Channel.imageStream] when the user picks or resets
/// a picture, since both flows persist eagerly) with an _Upload_ button
/// below. While an upload is in flight, a translucent overlay +
/// [StreamLoadingSpinner] is layered on top of the avatar — same pattern
/// as `StreamAttachmentUploadStateBuilder` in the SDK.
class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.uploadProgress,
    required this.onTap,
  });

  /// Determinate upload progress in [0, 1], or `null` when no upload is in
  /// flight. A `null` value while uploading is rendered as an indeterminate
  /// spinner — matches the SDK's fallback when content length is unknown.
  final double? uploadProgress;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final channel = StreamChannel.of(context).channel;
    final size = StreamAvatarGroupSize.xxl.value;

    return Column(
      children: [
        // Avatar is purely a preview — only the Upload button below
        // triggers the picker. Avoids two overlapping hit targets and
        // keeps the affordance unambiguous.
        Stack(
          alignment: Alignment.center,
          children: [
            StreamChannelAvatar(channel: channel, size: .xxl),
            if (uploadProgress != null)
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.backgroundOverlayLight,
                ),
                alignment: Alignment.center,
                child: StreamLoadingSpinner(
                  value: uploadProgress,
                  size: .md,
                ),
              ),
          ],
        ),
        SizedBox(height: spacing.xs),
        StreamButton(
          type: .ghost,
          style: .primary,
          size: .small,
          onPressed: onTap,
          child: const Text('Upload'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar picker (stacked)
// ---------------------------------------------------------------------------

enum _AvatarPickerAction { takePhoto, chooseImage, resetPicture }

Future<_AvatarPickerAction?> _showAvatarPickerSheet(BuildContext context) {
  return showStreamSheet<_AvatarPickerAction>(
    context: context,
    isDismissible: true,
    builder: (_, _) => const _AvatarPickerSheet(),
  );
}

class _AvatarPickerSheet extends StatelessWidget {
  const _AvatarPickerSheet();

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final icons = context.streamIcons;

    void emit(_AvatarPickerAction action) => Navigator.of(context).pop(action);

    return SafeArea(
      top: false,
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamSheetHeader(title: const Text('Edit Group Picture')),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamListTile(
                    leading: Icon(icons.camera),
                    title: const Text('Take Photo'),
                    onTap: () => emit(_AvatarPickerAction.takePhoto),
                  ),
                  StreamListTile(
                    leading: Icon(icons.image),
                    title: const Text('Choose Image'),
                    onTap: () => emit(_AvatarPickerAction.chooseImage),
                  ),
                  // Destructive — paint icon + label with accentError via a
                  // local theme override.
                  StreamListTileTheme(
                    data: context.streamListTileTheme.copyWith(
                      iconColor: WidgetStateProperty.all<Color?>(colorScheme.accentError),
                      titleColor: WidgetStateProperty.all<Color?>(colorScheme.accentError),
                    ),
                    child: StreamListTile(
                      leading: Icon(icons.delete),
                      title: const Text('Reset Picture'),
                      onTap: () => emit(_AvatarPickerAction.resetPicture),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
