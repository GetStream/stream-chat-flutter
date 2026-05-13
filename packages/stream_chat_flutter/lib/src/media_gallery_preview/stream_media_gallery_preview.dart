import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// A swipeable, full-screen viewer for a list of chat media attachments.
///
/// Wraps a [PageView] in a [core.StreamMediaViewer] whose chrome —
/// [StreamMediaGalleryPreviewHeader] on top, [StreamMediaGalleryPreviewFooter]
/// on the bottom — is composed internally from the active package.
///
/// Behaviour built in:
///
/// - Tapping the media area toggles the chrome (it slides off the top /
///   bottom edges while the background fades to immersive black).
/// - Keyboard shortcuts: ← / → advance pages, esc pops the enclosing route.
/// - The footer's gallery-grid button opens [StreamMediaGallery] in a
///   [showStreamSheet] bottom sheet; tapping a tile seeks the page view.
/// - The footer's share button downloads the active attachment's bytes and
///   hands them to the system share sheet.
/// - Video attachments are played by [StreamVideoPlayer], which pauses
///   itself when its page is no longer the active one (see
///   [StreamMediaGalleryPreviewScope]).
///
/// {@tool snippet}
///
/// Open the viewer at a specific attachment:
///
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(
///     builder: (_) => StreamChannel(
///       channel: channel,
///       child: StreamMediaGalleryPreview(
///         attachments: attachments,
///         initialIndex: 3,
///       ),
///     ),
///   ),
/// );
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// Substitute a custom preview implementation via the component factory:
///
/// ```dart
/// StreamComponentFactory(
///   builders: StreamComponentBuilders(
///     extensions: streamChatComponentBuilders(
///       mediaGalleryPreview: (context, props) => MyCustomPreview(props: props),
///     ),
///   ),
///   child: ...,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGalleryPreviewProps], which configures this widget.
///  * [DefaultStreamMediaGalleryPreview], the default implementation.
///  * [StreamMediaGalleryPreviewScope], which exposes the active page to
///    descendants (videos pause based on this).
///  * [StreamMediaGallery], the thumbnail companion shown in the footer's
///    bottom sheet.
class StreamMediaGalleryPreview extends StatelessWidget {
  /// Creates a [StreamMediaGalleryPreview].
  StreamMediaGalleryPreview({
    super.key,
    required List<StreamMediaGalleryAttachment> attachments,
    int initialIndex = 0,
    bool autoplayVideos = false,
  }) : assert(initialIndex >= 0, 'initialIndex cannot be negative'),
       props = .new(
         attachments: attachments,
         initialIndex: initialIndex,
         autoplayVideos: autoplayVideos,
       );

  /// The properties that configure this preview.
  final StreamMediaGalleryPreviewProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMediaGalleryPreviewProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMediaGalleryPreview(props: props);
  }
}

/// Properties for configuring a [StreamMediaGalleryPreview].
///
/// This class holds all configuration options for the preview, allowing
/// them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamMediaGalleryPreview], which uses these properties.
///  * [DefaultStreamMediaGalleryPreview], the default implementation.
@immutable
class StreamMediaGalleryPreviewProps {
  /// Creates properties for a media gallery preview.
  const StreamMediaGalleryPreviewProps({
    required this.attachments,
    this.initialIndex = 0,
    this.autoplayVideos = false,
  });

  /// The 0-based index of the attachment to show first.
  final int initialIndex;

  /// The attachments to browse.
  final List<StreamMediaGalleryAttachment> attachments;

  /// Whether video attachments auto-play when their page becomes active.
  final bool autoplayVideos;
}

/// The default implementation of [StreamMediaGalleryPreview].
///
/// See also:
///
///  * [StreamMediaGalleryPreview], the public API widget.
///  * [StreamMediaGalleryPreviewProps], which configures this widget.
class DefaultStreamMediaGalleryPreview extends StatefulWidget {
  /// Creates a default media gallery preview with the given [props].
  const DefaultStreamMediaGalleryPreview({super.key, required this.props});

  /// The properties that configure this preview.
  final StreamMediaGalleryPreviewProps props;

  @override
  State<DefaultStreamMediaGalleryPreview> createState() => _DefaultStreamMediaGalleryPreviewState();
}

class _DefaultStreamMediaGalleryPreviewState extends State<DefaultStreamMediaGalleryPreview> {
  late final _showChrome = ValueNotifier(true);
  late final _currentPage = ValueNotifier(widget.props.initialIndex);
  late final _pageController = PageController(initialPage: _currentPage.value);

  // Animates the page view to the given page index.
  Future<void> _animateToPage(int page) {
    return _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Downloads the currently-focused attachment's bytes and hands them to
  // the system share sheet.
  Future<void> _shareCurrentAttachment(BuildContext context) async {
    final attachment = widget.props.attachments[_currentPage.value].attachment;
    final url = attachment.imageUrl ?? attachment.assetUrl ?? attachment.thumbUrl;
    if (url == null) return;

    final response = await Dio().get<List<int>>(url, options: Options(responseType: .bytes));
    final data = response.data;
    if (data == null || data.isEmpty) return;

    // sharePositionOrigin anchors the iPad / macOS popover; without it the
    // share sheet asserts on those platforms.
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : Rect.zero;

    final params = ShareParams(
      sharePositionOrigin: origin,
      fileNameOverrides: [attachment.title ?? attachment.id],
      files: [XFile.fromData(Uint8List.fromList(data), mimeType: attachment.mimeType)],
    );

    await SharePlus.instance.share(params);
  }

  // Opens the thumbnail grid in a bottom sheet; tapping a tile pops the
  // sheet and seeks the page view to that index.
  Future<void> _openGallery(BuildContext context) async {
    final itemIndex = await showStreamSheet<int>(
      context: context,
      builder: (sheetContext, scrollController) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamSheetHeader(title: Text(sheetContext.translations.photosAndVideosLabel)),
          Expanded(
            child: StreamMediaGallery(
              attachments: widget.props.attachments,
              scrollController: scrollController,
              onItemTap: Navigator.of(sheetContext).maybePop,
            ),
          ),
        ],
      ),
    );

    if (itemIndex == null || !mounted) return;
    _animateToPage(itemIndex); // Animate the page to the selected index from the gallery.
  }

  @override
  void dispose() {
    _showChrome.dispose();
    _currentPage.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attachments = widget.props.attachments;
    final itemCount = attachments.length;

    final gallery = ValueListenableBuilder<bool>(
      valueListenable: _showChrome,
      builder: (context, showChrome, pageView) {
        return ValueListenableBuilder<int>(
          valueListenable: _currentPage,
          builder: (context, currentPage, _) {
            final translations = context.translations;
            final message = attachments[currentPage].message;

            final senderName = message.user?.name ?? '';
            final sentAt = translations.sentAtText(date: message.createdAt, time: message.createdAt);
            final pageCounter = translations.galleryPaginationText(currentPage: currentPage, totalPages: itemCount);

            return core.StreamMediaViewer(
              showChrome: showChrome,
              header: StreamMediaGalleryPreviewHeader(
                title: Text(senderName),
                subtitle: Text(sentAt),
              ),
              footer: StreamMediaGalleryPreviewFooter(
                title: Text(pageCounter),
                onSharePressed: () => _shareCurrentAttachment(context),
                onGalleryPressed: () => _openGallery(context),
              ),
              child: pageView!,
            );
          },
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showChrome.value = !_showChrome.value,
        child: PageView.builder(
          controller: _pageController,
          itemCount: itemCount,
          onPageChanged: (page) => _currentPage.value = page,
          itemBuilder: (_, index) {
            final package = attachments[index];
            return StreamMediaGalleryPreviewItem(
              attachment: package.attachment,
              pageIndex: index,
              autoplay: widget.props.autoplayVideos,
            );
          },
        ),
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: KeyboardShortcutRunner(
        onEscapeKeypress: Navigator.of(context).maybePop,
        onLeftArrowKeypress: () {
          final index = _currentPage.value;
          if (index > 0) _animateToPage(index - 1);
        },
        onRightArrowKeypress: () {
          final index = _currentPage.value;
          if (index < itemCount - 1) _animateToPage(index + 1);
        },
        child: StreamMediaGalleryPreviewScope._(
          activeIndex: _currentPage,
          child: gallery,
        ),
      ),
    );
  }
}

/// Exposes the active page index of the enclosing [StreamMediaGalleryPreview]
/// to descendants.
///
/// Per-page widgets that need to react when their page is no longer
/// visible — e.g. video players that pause themselves while off-screen —
/// read [activeIndex] from this scope and compare it against their own
/// page index.
///
/// {@tool snippet}
///
/// ```dart
/// final scope = StreamMediaGalleryPreviewScope.of(context);
/// final isActive = scope.activeIndex.value == myPageIndex;
/// ```
/// {@end-tool}
class StreamMediaGalleryPreviewScope extends InheritedWidget {
  const StreamMediaGalleryPreviewScope._({
    required this.activeIndex,
    required super.child,
  });

  /// The active page index of the enclosing preview.
  final ValueListenable<int> activeIndex;

  /// Returns the [StreamMediaGalleryPreviewScope] of the nearest enclosing
  /// [StreamMediaGalleryPreview], or `null` if there isn't one.
  ///
  /// Prefer [of] when the absence of the scope is a programmer error.
  static StreamMediaGalleryPreviewScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StreamMediaGalleryPreviewScope>();
  }

  /// Returns the [StreamMediaGalleryPreviewScope] of the nearest enclosing
  /// [StreamMediaGalleryPreview].
  ///
  /// Throws a [FlutterError] when no scope is in scope — typically because
  /// the calling widget is rendered outside the preview's page tree.
  /// Use [maybeOf] when the absence is a recoverable case.
  static StreamMediaGalleryPreviewScope of(BuildContext context) {
    final scope = maybeOf(context);
    if (scope != null) return scope;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamMediaGalleryPreviewScope.of() called with a context that '
        'does not contain a StreamMediaGalleryPreview.',
      ),
      ErrorDescription(
        'No StreamMediaGalleryPreview ancestor could be found starting '
        'from the context that was passed to '
        'StreamMediaGalleryPreviewScope.of(). This usually means the '
        'caller is being built outside the page tree owned by the '
        'preview, or the context predates the StreamMediaGalleryPreview '
        'itself.',
      ),
      ErrorHint(
        'The scope is only available inside widgets rendered by the '
        'preview — typically a [StreamMediaGalleryPreviewItem] or a '
        'replacement provided via the component factory. If you need to '
        'react to gallery activity from elsewhere, lift the state out of '
        'the preview instead.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  @override
  bool updateShouldNotify(StreamMediaGalleryPreviewScope old) => activeIndex != old.activeIndex;
}
