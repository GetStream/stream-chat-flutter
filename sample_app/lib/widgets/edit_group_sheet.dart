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
  late final StreamChatClient _client = StreamChat.of(context).client;
  late final TextEditingController _nameController = TextEditingController(
    text: _channel.name ?? '',
  );

  // Path to the picked image file on the local device. Drives the
  // preview via Image.file so the swap is instant (no CDN round-trip),
  // independent of the upload's URL state. Mirrors the LLC's
  // sendMessage attachment flow — local file is the source of truth
  // until the URL takes over on the server.
  String? _pickedPath;

  // CDN URL returned from the standalone upload. Used only to persist
  // the avatar on save — the in-sheet preview reads from [_pickedPath].
  String? _imageOverride;

  // True when the user tapped Reset Picture. Persisted as an `image`
  // unset only when save is tapped.
  bool _imageRemoved = false;

  bool _saving = false;

  // Determinate upload progress in [0, 1], or `null` when no upload is in
  // flight. Drives the spinner overlay on the avatar preview and gates the
  // save checkmark so users can't persist before the URL has settled.
  double? _uploadProgress;

  // Standalone uploads we've kicked off in this session. On save, we
  // strip the URL we're about to persist and delete the rest — they
  // were superseded by a later pick. On dispose without save, we
  // delete every entry so abandoned uploads don't leak on the CDN.
  final List<String> _trackedUploads = [];

  String get _name => _nameController.text.trim();
  String get _initialName => (_channel.extraData['name'] as String?) ?? '';

  bool get _isDirty {
    if (_name != _initialName) return true;
    if (_pickedPath != null) return true;
    if (_imageRemoved) return true;
    return false;
  }

  // Save is gated on at least one change *and* a non-empty name (the API
  // won't accept blanks) *and* no upload in flight (so we never persist a
  // stale URL).
  bool get _canSave => _isDirty && _name.isNotEmpty && !_saving && _uploadProgress == null;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    // Sheet was dismissed without saving — delete every standalone
    // upload we held on to. Save() clears the list before pop, so this
    // only fires for the abandon case.
    for (final url in _trackedUploads) {
      _deleteOrphan(url);
    }
    _trackedUploads.clear();
    super.dispose();
  }

  // Fire-and-forget cleanup of a CDN upload via the standalone delete
  // API. Failure to delete just leaks one orphan, which the user can
  // survive.
  void _deleteOrphan(String url) {
    _client.deleteImage(url, _channel.id!, _channel.type).ignore();
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
      child: Column(
        children: [
          StreamSheetHeader(
            title: const Text('Edit'),
            trailing: StreamButton.icon(
              icon: Icon(context.streamIcons.checkmark),
              type: .solid,
              onPressed: _canSave ? _save : null,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(spacing.md) + viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AvatarPreview(
                    pickedPath: _pickedPath,
                    imageOverride: _imageOverride,
                    imageRemoved: _imageRemoved,
                    uploadProgress: _uploadProgress,
                    onTap: _openAvatarPicker,
                  ),
                  SizedBox(height: spacing.xxl),
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
        _resetPicture();
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

    // Show the local file in the preview immediately (LLC pattern —
    // sendMessage's attachments render via attachment.file.path until
    // the upload settles). Clear any prior URL since it's superseded.
    setState(() {
      _pickedPath = picked.path;
      _imageOverride = null;
      _imageRemoved = false;
      // Start at `0` so the spinner appears as a determinate bar
      // immediately; the first onSendProgress callback may not arrive
      // for a few hundred ms on slow networks.
      _uploadProgress = 0;
    });

    try {
      // Standalone upload — returns a CDN URL we can persist on the
      // channel without creating a message.
      final response = await _client.sendImage(
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
      if (url == null || !mounted) return;
      _trackedUploads.add(url);
      setState(() => _imageOverride = url);
    } catch (e) {
      if (mounted) {
        // Drop the local preview so the user sees the channel revert —
        // the snackbar tells them why and they can re-pick.
        setState(() => _pickedPath = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadProgress = null);
    }
  }

  void _resetPicture() {
    setState(() {
      _pickedPath = null;
      _imageOverride = null;
      _imageRemoved = true;
    });
  }

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      // Single-round-trip persist — name changes, the new avatar URL,
      // or an `image` unset for a reset all flow through one
      // updatePartial.
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

      // Strip the saved URL from the orphan list so dispose() doesn't
      // delete what we just persisted; everything else (a previous pick
      // the user replaced before saving) is now genuinely orphaned —
      // delete it via the standalone API.
      if (_imageOverride case final saved?) _trackedUploads.remove(saved);
      for (final url in _trackedUploads) {
        _deleteOrphan(url);
      }
      _trackedUploads.clear();

      if (!mounted) return;
      navigator.pop(true);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      if (mounted) setState(() => _saving = false);
    }
  }
}

/// The hero avatar block — local picked-file preview, the uploaded
/// CDN URL once it's settled, the session "removed" preview, or the
/// channel's current avatar — with an _Upload_ button below. While an
/// upload is in flight, a translucent overlay + [StreamLoadingSpinner]
/// is layered on top of the avatar — same pattern as
/// `StreamAttachmentUploadStateBuilder` in the SDK.
class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.pickedPath,
    required this.imageOverride,
    required this.imageRemoved,
    required this.uploadProgress,
    required this.onTap,
  });

  /// Path to the picked image file on the local device. Used as the
  /// placeholder for the URL branch so the swap is seamless — while
  /// the CDN copy is being fetched, the file shows through.
  final String? pickedPath;

  /// CDN URL returned by the standalone upload. Once set, the preview
  /// reads from the URL (so memory doesn't hold the file image once we
  /// have the canonical CDN copy) — the [pickedPath] keeps acting as
  /// the placeholder during the brief network round-trip.
  final String? imageOverride;

  /// `true` after the user explicitly tapped Reset Picture. Falls back
  /// to the member-group avatar even if the channel still carries an
  /// image (it'll be unset on save).
  final bool imageRemoved;

  /// Determinate upload progress in [0, 1], or `null` when no upload is
  /// in flight. A `null` value while uploading renders as an
  /// indeterminate spinner — matches the SDK's fallback when content
  /// length is unknown.
  final double? uploadProgress;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final channel = StreamChannel.of(context).channel;
    final size = StreamAvatarGroupSize.xxl.value;

    Widget? filePlaceholder(String? path) {
      if (path == null) return null;
      return Image.file(
        File(path),
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }

    final base = switch ((imageOverride, pickedPath, imageRemoved)) {
      // Upload finished — render the CDN URL via StreamAvatar; the
      // local file (if still around) acts as the placeholder during
      // CachedNetworkImage's first fetch so there's no flicker on the
      // file→URL swap.
      (final url?, final path, _) => StreamAvatar(
        imageUrl: url,
        size: .xxl,
        placeholder: (_) => filePlaceholder(path) ?? _MemberFallbackAvatar(channel: channel),
      ),
      // Picked but upload not yet settled — render the local file via
      // Image.file slotted into StreamAvatar's placeholder so the
      // surrounding chrome (size, 1px border, circle clip) matches
      // StreamChannelAvatar's image branch pixel-for-pixel.
      (null, final path?, _) => StreamAvatar(
        imageUrl: null,
        size: .xxl,
        placeholder: (_) => filePlaceholder(path)!,
      ),
      // User reset — render the member-group fallback even if the
      // channel still carries an image (it'll be unset on save).
      (null, null, true) => _MemberFallbackAvatar(channel: channel),
      // Untouched — defer to the channel's current avatar; reloads
      // automatically off `channel.imageStream` if the image changes
      // out from under us.
      _ => StreamChannelAvatar(channel: channel, size: .xxl),
    };

    return Column(
      children: [
        // Avatar is purely a preview — only the Upload button below
        // triggers the picker. Avoids two overlapping hit targets and
        // keeps the affordance unambiguous.
        Stack(
          alignment: Alignment.center,
          children: [
            base,
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

/// Renders the member-group avatar fallback — used to preview the "reset
/// picture" state before save round-trips, and as the placeholder for an
/// in-flight network image.
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
    final icons = context.streamIcons;

    void emit(_AvatarPickerAction action) => Navigator.of(context).pop(action);

    return SafeArea(
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamSheetHeader(title: const Text('Edit Group Picture')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PickerTile(
                    icon: Icon(icons.camera),
                    label: const Text('Take Photo'),
                    onTap: () => emit(_AvatarPickerAction.takePhoto),
                  ),
                  _PickerTile(
                    icon: Icon(icons.image),
                    label: const Text('Choose Image'),
                    onTap: () => emit(_AvatarPickerAction.chooseImage),
                  ),
                  _PickerTile(
                    icon: Icon(icons.delete),
                    label: const Text('Reset Picture'),
                    destructive: true,
                    onTap: () => emit(_AvatarPickerAction.resetPicture),
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

/// A single tappable row in [_AvatarPickerSheet]. Mirrors the `_Tile` shape
/// used by `GroupInfoScreen` / `ChatInfoScreen` — same min tap target and
/// content padding, with a [destructive] flag that flips the icon and
/// label to [StreamColorScheme.accentError] via a local
/// [StreamListTileTheme] override.
class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final Widget icon;
  final Widget label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        iconColor: destructive ? .all(colorScheme.accentError) : null,
        titleColor: destructive ? .all(colorScheme.accentError) : null,
        minTileHeight: 44,
        contentPadding: .symmetric(horizontal: spacing.sm),
      ),
      child: StreamListTile(
        leading: icon,
        title: label,
        onTap: onTap,
      ),
    );
  }
}
