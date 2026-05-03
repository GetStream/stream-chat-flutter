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

  // Override URL the user picked + uploaded in this session. `null` means
  // "no override" — the current channel image flows through unchanged.
  String? _imageOverride;
  bool _imageRemoved = false;
  bool _saving = false;

  String get _name => _nameController.text.trim();
  String get _initialName => (_channel.extraData['name'] as String?) ?? '';

  bool get _isDirty {
    if (_name != _initialName) return true;
    if (_imageOverride != null) return true;
    if (_imageRemoved) return true;
    return false;
  }

  // Save is gated on at least one change *and* a non-empty name — an empty
  // group name isn't a meaningful identifier, so the API won't accept it.
  bool get _canSave => _isDirty && _name.isNotEmpty && !_saving;

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
        // The Expanded child below forces the column to fill the
        // available height, which in turn drags the sheet up to its
        // full-screen rest position — matching the Figma's "full sheet"
        // edit flow.
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamSheetHeader(
            title: const Text('Edit'),
            trailing: StreamButton.icon(
              icon: Icon(context.streamIcons.checkmark),
              type: .solid,
              size: .small,
              onPressed: _canSave ? _save : null,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: spacing.md,
                right: spacing.md,
                top: spacing.md,
                bottom: spacing.md + viewInsets.bottom,
              ),
              child: Column(
                children: [
                  _AvatarPreview(
                    imageOverride: _imageOverride,
                    imageRemoved: _imageRemoved,
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
        setState(() {
          _imageOverride = null;
          _imageRemoved = true;
        });
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

    setState(() => _saving = true);
    try {
      final client = StreamChat.of(context).client;
      // Standalone upload — returns a CDN URL we can persist on the
      // channel without creating a message.
      final response = await client.sendImage(
        attachmentFile,
        _channel.id!,
        _channel.type,
      );
      final url = response.file;
      if (url == null || !mounted) return;
      setState(() {
        _imageOverride = url;
        _imageRemoved = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      final set = <String, Object?>{};
      final unset = <String>[];

      if (_name != _initialName) set['name'] = _name;
      if (_imageOverride != null) {
        set['image'] = _imageOverride;
      } else if (_imageRemoved) {
        unset.add('image');
      }

      if (set.isNotEmpty || unset.isNotEmpty) {
        await _channel.updatePartial(set: set, unset: unset);
      }

      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      if (mounted) setState(() => _saving = false);
    }
  }
}

/// The hero avatar block — large channel avatar (or a session-level
/// override) with an _Upload_ text button below.
class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.imageOverride,
    required this.imageRemoved,
    required this.onTap,
  });

  /// Session-only override URL — set after a successful upload.
  final String? imageOverride;

  /// `true` after the user explicitly removed the picture.
  final bool imageRemoved;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final channel = StreamChannel.of(context).channel;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: switch ((imageOverride, imageRemoved)) {
            // Just-uploaded image — show it directly. The xxl group-avatar
            // diameter is 80; mirror it here so the preview swap is
            // visually seamless.
            (final url?, _) => CircleAvatar(
              radius: StreamAvatarGroupSize.xxl.value / 2,
              backgroundImage: NetworkImage(url),
            ),
            // User reset — render the member-group fallback even if the
            // channel still carries an image (it'll be unset on save).
            (null, true) => _MemberFallbackAvatar(channel: channel),
            // Untouched — defer to the channel's current avatar.
            _ => StreamChannelAvatar(channel: channel, size: .xxl),
          },
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

/// Renders the member-group avatar fallback — used to preview the "reset
/// picture" state before the save round-trips.
class _MemberFallbackAvatar extends StatelessWidget {
  const _MemberFallbackAvatar({required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return BetterStreamBuilder<List<Member>>(
      stream: channel.state!.membersStream,
      initialData: channel.state!.members,
      builder: (context, members) {
        final users = [
          for (final m in members)
            if (m.user case final user?) user,
        ];
        return StreamUserAvatarGroup(users: users, size: .xxl);
      },
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
