import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter_ai/src/composer/ai_composer_controller.dart';
import 'package:stream_chat_flutter_ai/src/composer/chat_option.dart';
import 'package:stream_chat_flutter_ai/src/composer/stream_ai_composer_factory.dart';

/// The combined attachment / chat-option sheet opened from the composer's
/// leading "+" button by default (see [StreamAIComposerFactory.buildLeading]).
///
/// Shows, in a single scrollable sheet:
/// - A camera tile and a horizontal strip of the user's recent photos, each
///   tappable to toggle it in/out of [AiComposerController.attachments].
///   Selecting a photo takes effect immediately — there is no separate
///   confirm step, so the sheet can stay open while the user picks several.
/// - An "All Photos" button that opens the platform's full image picker.
/// - Below that (only if non-empty), [AiComposerController.chatOptions] as a
///   list of selectable rows (icon, title, subtitle) — tapping one calls
///   [AiComposerController.selectChatOption] and closes the sheet.
///
/// Requires platform permissions for gallery access:
///
/// **iOS** — add to `ios/Runner/Info.plist`:
/// ```xml
/// <key>NSPhotoLibraryUsageDescription</key>
/// <string>Photo library access is needed to attach images to your message.</string>
/// <key>NSCameraUsageDescription</key>
/// <string>Camera access is needed to attach a new photo to your message.</string>
/// ```
///
/// **Android** — add to `android/app/src/main/AndroidManifest.xml`:
/// ```xml
/// <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
/// <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
/// ```
class ComposerAttachmentSheet extends StatefulWidget {
  /// Creates a [ComposerAttachmentSheet].
  const ComposerAttachmentSheet({super.key, required this.controller});

  /// The controller whose [AiComposerController.attachments] and
  /// [AiComposerController.chatOptions] this sheet reads and mutates.
  final AiComposerController controller;

  @override
  State<ComposerAttachmentSheet> createState() => _ComposerAttachmentSheetState();
}

class _ComposerAttachmentSheetState extends State<ComposerAttachmentSheet> {
  static const int _recentPhotoLimit = 30;
  static const double _tileSize = 72;

  List<AssetEntity> _recentPhotos = const [];

  /// Maps a selected asset's id to the exact [XFile] instance passed to
  /// [AiComposerController.addAttachments], so deselecting can pass that same
  /// instance back to [AiComposerController.removeAttachment].
  ///
  /// [XFile] doesn't override `==`, so a freshly-constructed `XFile` with the
  /// same path is *not* `==` to the one already in
  /// [AiComposerController.attachments] — reconstructing one to remove would
  /// silently fail to match.
  final Map<String, XFile> _selectedAssets = {};

  bool _isLoading = true;
  bool _hasAccess = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadRecentPhotos());
  }

  Future<void> _loadRecentPhotos() async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.hasAccess) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final paths = await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      final assets = paths.isEmpty
          ? const <AssetEntity>[]
          : await paths.first.getAssetListRange(start: 0, end: _recentPhotoLimit);

      if (!mounted) return;
      setState(() {
        _recentPhotos = assets;
        _hasAccess = true;
        _isLoading = false;
      });
    } catch (_) {
      // No platform gallery implementation available (e.g. web, desktop
      // without native setup, or a test environment) — fall back to the
      // "no access" state so the camera tile and chat options still render.
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleAsset(AssetEntity asset) async {
    final selected = _selectedAssets[asset.id];
    if (selected != null) {
      setState(() => _selectedAssets.remove(asset.id));
      widget.controller.removeAttachment(selected);
      return;
    }

    final file = await asset.file;
    if (file == null || !mounted) return;
    final xFile = XFile(file.path);
    setState(() => _selectedAssets[asset.id] = xFile);
    widget.controller.addAttachments([xFile]);
  }

  Future<void> _pickFromCamera() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo == null) return;
    widget.controller.addAttachments([photo]);
  }

  Future<void> _pickFromFullLibrary() async {
    final photos = await ImagePicker().pickMultiImage(limit: StreamAIComposerFactory.maxAttachments);
    if (photos.isEmpty) return;
    widget.controller.addAttachments(photos);
  }

  void _selectChatOption(ChatOption option) {
    widget.controller.selectChatOption(option);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final chatOptions = widget.controller.chatOptions;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Text('Photos', style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  TextButton(onPressed: _pickFromFullLibrary, child: const Text('All Photos')),
                ],
              ),
            ),
            SizedBox(
              height: _tileSize,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CameraTile(onTap: _pickFromCamera),
                  const SizedBox(width: 8),
                  if (_isLoading)
                    const SizedBox(
                      width: _tileSize,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (!_hasAccess)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: TextButton(
                          onPressed: PhotoManager.openSetting,
                          child: Text('Allow photo access'),
                        ),
                      ),
                    )
                  else
                    for (final asset in _recentPhotos) ...[
                      _RecentPhotoTile(
                        asset: asset,
                        selected: _selectedAssets.containsKey(asset.id),
                        onTap: () => _toggleAsset(asset),
                      ),
                      const SizedBox(width: 8),
                    ],
                ],
              ),
            ),
            if (chatOptions.isNotEmpty) ...[
              Divider(height: 24, color: colorScheme.outlineVariant),
              for (final option in chatOptions) _ChatOptionTile(option: option, onTap: () => _selectChatOption(option)),
            ],
          ],
        ),
      ),
    );
  }
}

class _CameraTile extends StatelessWidget {
  const _CameraTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.camera_alt_outlined, color: colorScheme.onSurface),
      ),
    );
  }
}

class _RecentPhotoTile extends StatelessWidget {
  const _RecentPhotoTile({required this.asset, required this.selected, required this.onTap});

  final AssetEntity asset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<Uint8List?>(
                future: asset.thumbnailDataWithSize(const ThumbnailSize.square(200)),
                builder: (context, snapshot) {
                  final bytes = snapshot.data;
                  if (bytes == null) {
                    return ColoredBox(color: colorScheme.surfaceContainerHigh);
                  }
                  return Image.memory(bytes, fit: BoxFit.cover);
                },
              ),
            ),
            if (selected)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary, width: 3),
                ),
              ),
            if (selected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChatOptionTile extends StatelessWidget {
  const _ChatOptionTile({required this.option, required this.onTap});

  final ChatOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: option.icon != null ? Icon(option.icon, color: colorScheme.onSurface) : null,
      title: Text(option.text),
      subtitle: option.description != null ? Text(option.description!) : null,
      onTap: onTap,
    );
  }
}
