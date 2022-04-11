import 'package:cached_network_image/cached_network_image.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/context_menu_items/download_menu_item.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/full_screen_media_widget.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Returns an instance of [FullScreenMediaDesktop].
///
/// This should ONLY be used in [FullScreenMediaBuilder].
FullScreenMediaWidget getFsm({
  Key? key,
  required Message message,
  required List<Attachment> mediaAttachments,
  required int startIndex,
  required String userName,
  ShowMessageCallback? onShowMessage,
  AttachmentActionsBuilder? attachmentActionsModalBuilder,
  required bool autoplayVideos,
}) {
  return FullScreenMediaDesktop(
    key: key,
    mediaAttachments: mediaAttachments,
    message: message,
    autoplayVideos: autoplayVideos,
    startIndex: startIndex,
    attachmentActionsModalBuilder: attachmentActionsModalBuilder,
    onShowMessage: onShowMessage,
    userName: userName,
  );
}

/// A full screen image widget
class FullScreenMediaDesktop extends FullScreenMediaWidget {
  /// Instantiate a new FullScreenImage
  const FullScreenMediaDesktop({
    Key? key,
    required this.mediaAttachments,
    required this.message,
    this.startIndex = 0,
    String? userName,
    this.onShowMessage,
    this.attachmentActionsModalBuilder,
    this.autoplayVideos = false,
  })  : userName = userName ?? '',
        super(key: key);

  /// The url of the image
  final List<Attachment> mediaAttachments;

  /// Message where attachments are attached
  final Message message;

  /// First index of media shown
  final int startIndex;

  /// Username of sender
  final String userName;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Auto-play videos when page is opened
  final bool autoplayVideos;

  @override
  _FullScreenMediaDesktopState createState() => _FullScreenMediaDesktopState();
}

class _FullScreenMediaDesktopState extends State<FullScreenMediaDesktop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final PageController _pageController;

  late final _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  final _opacityTween = Tween<double>(begin: 1, end: 0);
  late final _opacityAnimation = _opacityTween.animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    ),
  );

  late final ValueNotifier<int> _currentPage = ValueNotifier(widget.startIndex);

  final videoPackages = <String, DesktopVideoPackage>{};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController(initialPage: widget.startIndex);
    for (var i = 0; i < widget.mediaAttachments.length; i++) {
      final attachment = widget.mediaAttachments[i];
      if (attachment.type != 'video') continue;
      final package = DesktopVideoPackage(attachment);
      videoPackages[attachment.id] = package;
    }
  }

  void onDownloadSuccess() {
    showDialog(
      context: context,
      builder: (_) => const MessageDialog(
        titleText: 'Download Successful!',
        showMessage: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.mediaAttachments.length != videoPackages.length
          ? Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (val) {
                    _currentPage.value = val;

                    if (videoPackages.isEmpty) {
                      return;
                    }

                    final currentAttachment = widget.mediaAttachments[val];

                    for (final p in videoPackages.values) {
                      if (p.attachment != currentAttachment) {
                        p.player.pause();
                      }
                    }

                    if (widget.autoplayVideos &&
                        currentAttachment.type == 'video') {
                      final package = videoPackages[currentAttachment.id]!;
                      package.player.play();
                    }
                  },
                  itemBuilder: (context, index) {
                    final attachment = widget.mediaAttachments[index];
                    if (attachment.type == 'image' ||
                        attachment.type == 'giphy') {
                      final imageUrl = attachment.imageUrl ??
                          attachment.assetUrl ??
                          attachment.thumbUrl;
                      return AnimatedBuilder(
                        animation: _curvedAnimation,
                        builder: (context, child) => ContextMenuArea(
                          verticalPadding: 0,
                          builder: (_) => [
                            DownloadMenuItem(
                              attachment: attachment,
                            ),
                          ],
                          child: PhotoView(
                            loadingBuilder: (context, image) =>
                                const Offstage(),
                            imageProvider: (imageUrl == null &&
                                    attachment.localUri != null &&
                                    attachment.file?.bytes != null)
                                ? Image.memory(attachment.file!.bytes!).image
                                : CachedNetworkImageProvider(imageUrl!),
                            maxScale: PhotoViewComputedScale.covered,
                            minScale: PhotoViewComputedScale.contained,
                            heroAttributes: PhotoViewHeroAttributes(
                              tag: widget.mediaAttachments,
                            ),
                            backgroundDecoration: BoxDecoration(
                              color: ColorTween(
                                begin:
                                    StreamChannelHeaderTheme.of(context).color,
                                end: Colors.black,
                              ).lerp(_curvedAnimation.value),
                            ),
                            onTapUp: (a, b, c) {
                              if (_animationController.isCompleted) {
                                _animationController.reverse();
                              } else {
                                _animationController.forward();
                              }
                            },
                          ),
                        ),
                      );
                    } else if (attachment.type == 'video') {
                      final package = videoPackages[attachment.id]!;
                      package.player.open(
                        Playlist(
                          medias: [
                            Media.network(package.attachment.assetUrl),
                          ],
                        ),
                        autoStart: widget.autoplayVideos,
                      );
                      return InkWell(
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          if (_animationController.isCompleted) {
                            _animationController.reverse();
                          } else {
                            _animationController.forward();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 50,
                          ),
                          child: ContextMenuArea(
                            verticalPadding: 0,
                            builder: (_) => [
                              DownloadMenuItem(
                                attachment: attachment,
                              ),
                            ],
                            child: Video(
                              player: package.player,
                              playlistLength: videoPackages.values.length,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  itemCount: widget.mediaAttachments.length,
                ),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, value, child) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamGalleryHeader(
                          userName: widget.userName,
                          sentAt: context.translations.sentAtText(
                            date: widget.message.createdAt,
                            time: widget.message.createdAt,
                          ),
                          onBackPressed: () => Navigator.of(context).pop(),
                          message: widget.message,
                          currentIndex: value,
                          onShowMessage: () {
                            widget.onShowMessage?.call(
                              widget.message,
                              StreamChannel.of(context).channel,
                            );
                          },
                          attachmentActionsModalBuilder:
                              widget.attachmentActionsModalBuilder,
                        ),
                        if (!widget.message.isEphemeral)
                          StreamGalleryFooter(
                            currentPage: value,
                            totalPages: widget.mediaAttachments.length,
                            mediaAttachments: widget.mediaAttachments,
                            message: widget.message,
                            mediaSelectedCallBack: (val) {
                              _currentPage.value = val;
                              _pageController.animateToPage(
                                val,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.mediaAttachments.length > 1) ...[
                  if (_currentPage.value !=
                      widget.mediaAttachments.length - 1) ...[
                    GalleryNavigationItem(
                      icon: Icons.chevron_right,
                      right: 0,
                      opacityAnimation: _opacityAnimation,
                      currentPage: _currentPage,
                      onClick: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeIn,
                        );
                        setState(() => _currentPage.value++);
                      },
                    ),
                  ],
                  if (_currentPage.value != 0) ...[
                    GalleryNavigationItem(
                      icon: Icons.chevron_left,
                      left: 0,
                      opacityAnimation: _opacityAnimation,
                      currentPage: _currentPage,
                      onClick: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOut,
                        );
                        setState(() => _currentPage.value--);
                      },
                    ),
                  ],
                ],
              ],
            )
          : Stack(
              children: [
                ContextMenuArea(
                  verticalPadding: 0,
                  builder: (_) => [
                    DownloadMenuItem(
                      attachment: videoPackages.values
                          .toList()[_currentPage.value]
                          .attachment,
                    ),
                  ],
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
                      child: StreamSvgIcon.close(
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

/// A widget for desktop and web users to be able to navigate left and right
/// through a gallery of images.
class GalleryNavigationItem extends StatelessWidget {
  /// Builds a [GalleryNavigationItem].
  const GalleryNavigationItem({
    Key? key,
    required this.icon,
    required this.onClick,
    required this.opacityAnimation,
    required this.currentPage,
    this.left,
    this.right,
  }) : super(key: key);

  /// The icon to display.
  final IconData icon;

  /// The callback to perform when the button is clicked.
  final VoidCallback onClick;

  /// The animation for showing & hiding this widget.
  final Animation<double> opacityAnimation;

  /// The value to use for .
  final ValueNotifier<int> currentPage;

  /// The left-hand placement of the button.
  final double? left;

  /// The right-hand placement of the button.
  final double? right;

  @override
  Widget build(BuildContext context) {
    return PlatformWidgetBuilder(
      desktop: (_, child) => child,
      web: (_, child) => child,
      child: Positioned(
        left: left,
        right: right,
        top: MediaQuery.of(context).size.height / 2,
        child: FadeTransition(
          opacity: opacityAnimation,
          child: ValueListenableBuilder<int>(
            valueListenable: currentPage,
            builder: (context, value, child) => GestureDetector(
              onTap: onClick,
              child: Icon(
                icon,
                size: 50,
              ),
            ),
            child: GestureDetector(
              onTap: onClick,
              child: Icon(
                icon,
                size: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Class for packaging up things required for videos
class DesktopVideoPackage {
  /// Constructor for creating [VideoPackage]
  DesktopVideoPackage(
    this.attachment, {
    this.showControls = true,
  }) : player = Player(
          id: int.parse(
            attachment.id.characters
                .getRange(0, 10)
                .toString()
                .replaceAll(RegExp('[^0-9]'), ''),
          ),
        );

  /// The video attachment to play.
  final Attachment attachment;

  /// The VLC player to use.
  final Player player;

  /// Whether to show the player controls or not.
  final bool showControls;
}

class _PlaylistPlayer extends StatelessWidget {
  const _PlaylistPlayer({
    Key? key,
    required this.packages,
    required this.autoStart,
  }) : super(key: key);

  final List<DesktopVideoPackage> packages;
  final bool autoStart;

  @override
  Widget build(BuildContext context) {
    final _media = <Media>[];
    for (final package in packages) {
      _media.add(Media.network(package.attachment.assetUrl));
    }
    packages.first.player.open(
      Playlist(
        medias: _media,
      ),
      autoStart: autoStart,
    );
    return Video(
      player: packages.first.player,
      fit: BoxFit.cover,
      playlistLength: packages.length,
    );
  }
}
