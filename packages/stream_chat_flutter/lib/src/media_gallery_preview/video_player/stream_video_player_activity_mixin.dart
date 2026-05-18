import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// State mixin for playback controllers (video / audio) that want to
/// behave well inside a [StreamMediaGalleryPreview].
///
/// When the widget is hosted inside a preview, the mixin subscribes to the
/// enclosing [StreamMediaGalleryPreviewScope]'s active page index and
/// toggles playback so:
///
/// - When the page becomes active again, playback resumes if the user had
///   it playing before swiping away — or if [autoplay] is true on the
///   first activation.
/// - When the page goes off-screen, playback pauses; the prior state is
///   remembered so swiping back doesn't drop the user's position or
///   force-restart paused videos.
///
/// When there is no preview ancestor, the mixin treats the widget as
/// always active — [autoplay] kicks in on init and the caller controls
/// play / pause manually after that. This lets the same player class be
/// reused outside the gallery without breaking.
mixin StreamVideoPlayerActivityMixin<T extends StatefulWidget> on State<T> {
  ValueListenable<int>? _activeIndex;
  bool _wasPlayingBeforeInactive = false;

  /// The 0-based index of this page in the enclosing
  /// [StreamMediaGalleryPreview]. Ignored when no preview ancestor is in
  /// scope.
  int get pageIndex;

  /// Whether playback should auto-start when this page first becomes
  /// active. Already-paused-by-user state is preserved on re-activation
  /// regardless of this flag.
  bool get autoplay;

  /// Whether the underlying controller is ready for [play] / [pause]
  /// calls. The mixin gates its sync on this flag so subclasses can
  /// safely return false during async initialisation.
  bool get isPlayerReady;

  /// Whether the underlying controller is currently playing.
  bool get isPlaying;

  /// Starts playback. Called only when [isPlayerReady] is true.
  void play();

  /// Pauses playback. Called only when [isPlayerReady] is true.
  void pause();

  /// True when this page is currently the active gallery page.
  ///
  /// Treated as always active when no [StreamMediaGalleryPreviewScope]
  /// ancestor is in scope, so the player still auto-plays / can be
  /// controlled manually outside the gallery.
  bool get isActive => _activeIndex == null || _activeIndex!.value == pageIndex;

  /// Subclasses should call this when their async initialisation completes
  /// so the mixin can apply the right initial play / pause state.
  void syncPlayState() => _syncPlayState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = StreamMediaGalleryPreviewScope.maybeOf(context)?.activeIndex;
    if (_activeIndex != next) {
      _activeIndex?.removeListener(_syncPlayState);
      _activeIndex = next?..addListener(_syncPlayState);
      _syncPlayState();
    }
  }

  @override
  void dispose() {
    _activeIndex?.removeListener(_syncPlayState);
    super.dispose();
  }

  void _syncPlayState() {
    if (!isPlayerReady) return;
    if (isActive) {
      if (autoplay || _wasPlayingBeforeInactive) {
        play();
        _wasPlayingBeforeInactive = false;
      }
    } else if (isPlaying) {
      _wasPlayingBeforeInactive = true;
      pause();
    }
  }
}
