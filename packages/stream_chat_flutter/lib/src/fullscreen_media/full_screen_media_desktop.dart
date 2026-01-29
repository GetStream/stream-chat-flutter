import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/context_menu/context_menu.dart';
import 'package:stream_chat_flutter/src/context_menu/context_menu_region.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/full_screen_media_widget.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/gallery_navigation_item.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Returns an instance of [FullScreenMediaDesktop].
///
/// This should ONLY be used in [FullScreenMediaBuilder].
FullScreenMediaWidget getFsm({
  Key? key,
  required List<StreamAttachmentPackage> mediaAttachmentPackages,
  required int startIndex,
  required String userName,
  ShowMessageCallback? onShowMessage,
  ReplyMessageCallback? onReplyMessage,
  AttachmentActionsBuilder? attachmentActionsModalBuilder,
  bool? autoplayVideos,
}) {
  return FullScreenMediaDesktop(
    key: key,
    mediaAttachmentPackages: mediaAttachmentPackages,
    startIndex: startIndex,
    userName: userName,
    onReplyMessage: onReplyMessage,
    onShowMessage: onShowMessage,
    attachmentActionsModalBuilder: attachmentActionsModalBuilder,
    autoplayVideos: autoplayVideos ?? false,
  );
}

/// A full screen image widget
class FullScreenMediaDesktop extends FullScreenMediaWidget {
  /// Instantiate a new FullScreenImage
  const FullScreenMediaDesktop({
    super.key,
    required this.mediaAttachmentPackages,
    this.startIndex = 0,
    String? userName,
    this.onShowMessage,
    this.onReplyMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  }) : userName = userName ?? '';

  /// The url of the image
  final List<StreamAttachmentPackage> mediaAttachmentPackages;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Callback for when reply message is tapped
  final ReplyMessageCallback? onReplyMessage;

  /// Widget builder for attachment actions modal
  /// [defaultActionsModal] is the default [AttachmentActionsModal] config
  /// Use [defaultActionsModal.copyWith] to easily customize it
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  _FullScreenMediaDesktopState createState() => _FullScreenMediaDesktopState();
}

class _FullScreenMediaDesktopState extends State<FullScreenMediaDesktop> {
  late final PageController _pageController;

  late final _currentPage = ValueNotifier(widget.startIndex);
  late final _isDisplayingDetail = ValueNotifier<bool>(true);

  void switchDisplayingDetail() {
    _isDisplayingDetail.value = !_isDisplayingDetail.value;
  }

  final videoPackages = <String, DesktopVideoPackage>{};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startIndex);
    for (var i = 0; i < widget.mediaAttachmentPackages.length; i++) {
      final attachment = widget.mediaAttachmentPackages[i].attachment;
      if (attachment.type != AttachmentType.video) continue;
      final package = DesktopVideoPackage(attachment);
      videoPackages[attachment.id] = package;
    }
  }

  @override
  void dispose() {
    _currentPage.dispose();
    _pageController.dispose();
    _isDisplayingDetail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final containsOnlyVideos = widget.mediaAttachmentPackages.length == videoPackages.length;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: containsOnlyVideos ? _buildVideoPageView() : _buildPageView(),
    );
  }

  Widget _buildVideoPageView() {
    return Stack(
      children: [
        ContextMenuRegion(
          contextMenuBuilder: (context, anchor) {
            final index = _currentPage.value;
            final mediaAttachment = widget.mediaAttachmentPackages[index];
            return ContextMenu(
              anchor: anchor,
              menuItems: [_DownloadMenuItem(mediaAttachment: mediaAttachment)],
            );
          },
          child: _PlaylistPlayer(
            packages: videoPackages.values.toList(),
            autoStart: widget.autoplayVideos,
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                videoPackages.values.first.player.stop();
                Navigator.of(context).pop();
              },
              child: const StreamSvgIcon(
                size: 30,
                icon: StreamSvgIcons.close,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentPage,
      builder: (context, currentPage, child) {
        final _currentAttachmentPackage = widget.mediaAttachmentPackages[currentPage];
        final _currentMessage = _currentAttachmentPackage.message;
        final _currentAttachment = _currentAttachmentPackage.attachment;
        return Stack(
          children: [
            child!,
            ValueListenableBuilder<bool>(
              valueListenable: _isDisplayingDetail,
              builder: (context, isDisplayingDetail, child) {
                final mediaQuery = MediaQuery.of(context);
                final topPadding = mediaQuery.padding.top;
                return AnimatedPositionedDirectional(
                  duration: kThemeAnimationDuration,
                  curve: Curves.easeInOut,
                  top: isDisplayingDetail ? 0 : -(topPadding + kToolbarHeight),
                  start: 0,
                  end: 0,
                  height: topPadding + kToolbarHeight,
                  child: StreamGalleryHeader(
                    userName: widget.userName,
                    sentAt: context.translations.sentAtText(
                      date: _currentAttachmentPackage.message.createdAt,
                      time: _currentAttachmentPackage.message.createdAt,
                    ),
                    onBackPressed: Navigator.of(context).pop,
                    message: _currentMessage,
                    attachment: _currentAttachment,
                    onShowMessage: () {
                      widget.onShowMessage?.call(
                        _currentMessage,
                        StreamChannel.of(context).channel,
                      );
                    },
                    attachmentActionsModalBuilder: widget.attachmentActionsModalBuilder,
                  ),
                );
              },
            ),
            if (!_currentMessage.isEphemeral)
              ValueListenableBuilder<bool>(
                valueListenable: _isDisplayingDetail,
                builder: (context, isDisplayingDetail, child) {
                  final mediaQuery = MediaQuery.of(context);
                  final bottomPadding = mediaQuery.padding.bottom;
                  return AnimatedPositionedDirectional(
                    duration: kThemeAnimationDuration,
                    curve: Curves.easeInOut,
                    bottom: isDisplayingDetail ? 0 : -(bottomPadding + kToolbarHeight),
                    start: 0,
                    end: 0,
                    height: bottomPadding + kToolbarHeight,
                    child: StreamGalleryFooter(
                      currentPage: currentPage,
                      totalPages: widget.mediaAttachmentPackages.length,
                      mediaAttachmentPackages: widget.mediaAttachmentPackages,
                      mediaSelectedCallBack: (val) {
                        _currentPage.value = val;
                        _pageController.animateToPage(
                          val,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            if (widget.mediaAttachmentPackages.length > 1) ...[
              if (currentPage > 0)
                GalleryNavigationItem(
                  left: 8,
                  opacityAnimation: _isDisplayingDetail,
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () {
                    _currentPage.value--;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              if (currentPage < widget.mediaAttachmentPackages.length - 1)
                GalleryNavigationItem(
                  right: 8,
                  opacityAnimation: _isDisplayingDetail,
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () {
                    _currentPage.value++;
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
            ],
          ],
        );
      },
      child: InkWell(
        onTap: switchDisplayingDetail,
        child: KeyboardShortcutRunner(
          onEscapeKeypress: Navigator.of(context).pop,
          onLeftArrowKeypress: () {
            if (_currentPage.value > 0) {
              _currentPage.value--;
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          onRightArrowKeypress: () {
            if (_currentPage.value < widget.mediaAttachmentPackages.length - 1) {
              _currentPage.value++;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaAttachmentPackages.length,
            onPageChanged: (val) {
              _currentPage.value = val;
              if (videoPackages.isEmpty) return;
              final currentAttachment = widget.mediaAttachmentPackages[val].attachment;
              for (final p in videoPackages.values) {
                if (p.attachment != currentAttachment) {
                  p.player.pause();
                }
              }
              if (widget.autoplayVideos && currentAttachment.type == AttachmentType.video) {
                final package = videoPackages[currentAttachment.id]!;
                package.player.play();
              }
            },
            itemBuilder: (context, index) {
              final currentAttachmentPackage = widget.mediaAttachmentPackages[index];
              final attachment = currentAttachmentPackage.attachment;

              return ValueListenableBuilder(
                valueListenable: _isDisplayingDetail,
                builder: (context, isDisplayingDetail, child) {
                  final padding = MediaQuery.paddingOf(context);

                  return AnimatedContainer(
                    duration: kThemeChangeDuration,
                    color: switch (isDisplayingDetail) {
                      true => StreamChannelHeaderTheme.of(context).color,
                      false => Colors.black,
                    },
                    padding: EdgeInsetsDirectional.only(
                      top: padding.top + kToolbarHeight,
                      bottom: padding.bottom + kToolbarHeight,
                    ),
                    child: child,
                  );
                },
                child: Builder(
                  builder: (context) {
                    if (attachment.type == AttachmentType.image || attachment.type == AttachmentType.giphy) {
                      return PhotoView.customChild(
                        maxScale: PhotoViewComputedScale.covered,
                        minScale: PhotoViewComputedScale.contained,
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: StreamMediaAttachmentThumbnail(
                          media: attachment,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    } else if (attachment.type == AttachmentType.video) {
                      final package = videoPackages[attachment.id]!;
                      if (package.attachment.assetUrl != null) {
                        package.player.open(
                          Playlist(
                            [
                              Media(package.attachment.assetUrl!),
                            ],
                          ),
                          play: widget.autoplayVideos,
                        );
                      }

                      return ContextMenuRegion(
                        contextMenuBuilder: (_, anchor) {
                          return ContextMenu(
                            anchor: anchor,
                            menuItems: [
                              _DownloadMenuItem(
                                mediaAttachment: currentAttachmentPackage,
                              ),
                            ],
                          );
                        },
                        child: Video(
                          controller: package.controller,
                        ),
                      );
                    }

                    return const Empty();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// {@template streamDownloadMenuItem}
/// A context menu item for downloading an attachment from a message.
///
/// This widget displays a download option in a context menu, allowing users to
/// download the attachment associated with a message.
///
/// It uses [StreamMessageActionItem] and [StreamMessageAction] to create a
/// consistent UI with other message actions.
/// {@endtemplate}
class _DownloadMenuItem extends StatelessWidget {
  /// {@macro streamDownloadMenuItem}
  const _DownloadMenuItem({
    required this.mediaAttachment,
  });

  /// The attachment package containing the message and attachment to download.
  final StreamAttachmentPackage mediaAttachment;
  static const String _attachmentKey = 'attachment';

  @override
  Widget build(BuildContext context) {
    return StreamMessageActionItem(
      action: StreamMessageAction(
        leading: const StreamSvgIcon(icon: StreamSvgIcons.download),
        title: Text(context.translations.downloadLabel),
        action: CustomMessageAction(
          message: mediaAttachment.message,
          extraData: {_attachmentKey: mediaAttachment.attachment},
        ),
      ),
      // TODO: Use a callback to handle the action instead of onTap.
      onTap: (action) async {
        if (action is! CustomMessageAction) return;
        final attachment = action.extraData[_attachmentKey] as Attachment?;
        if (attachment == null) return;

        final popped = await Navigator.of(context).maybePop();
        if (popped) {
          final handler = StreamAttachmentHandler.instance;
          return handler.downloadAttachment(attachment).ignore();
        }
      },
    );
  }
}

/// Class for packaging up things required for videos
class DesktopVideoPackage {
  /// Constructor for creating [VideoPackage]
  factory DesktopVideoPackage(
    Attachment attachment, {
    bool showControls = true,
  }) {
    final player = Player();
    final controller = VideoController(player);
    return DesktopVideoPackage._internal(
      attachment,
      player,
      controller,
      showControls,
    );
  }

  DesktopVideoPackage._internal(
    this.attachment,
    this.player,
    this.controller,
    this.showControls,
  );

  /// The video attachment to play.
  final Attachment attachment;

  /// The VLC player to use.
  final Player player;

  /// The VLC video controller to use.
  final VideoController controller;

  /// Whether to show the player controls or not.
  final bool showControls;
}

class _PlaylistPlayer extends StatelessWidget {
  const _PlaylistPlayer({
    required this.packages,
    required this.autoStart,
  });

  final List<DesktopVideoPackage> packages;
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    final _media = <Media>[];
    for (final package in packages) {
      if (package.attachment.assetUrl != null) {
        _media.add(Media(package.attachment.assetUrl!));
      }
    }
    packages.first.player.open(
      Playlist(
        _media,
      ),
      play: autoStart,
    );
    return Video(
      controller: packages.first.controller,
      fit: BoxFit.cover,
    );
  }
}
