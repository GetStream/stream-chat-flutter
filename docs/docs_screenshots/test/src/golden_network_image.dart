import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart';

/// Avatar fixtures sourced from Stream's Chat SDK Design System (Figma node
/// `2867:55922`, "User Photo"). Each PNG is an 80×80 crop of a named sample
/// user; the file name matches the Figma component slug
/// (e.g. `Amelia Moore` → `amelia-moore.png`).
///
/// At test time, [goldenNetworkImageBuilder] extracts the slug from
/// `props.url`'s last path segment and looks it up in the fixture cache.
/// URLs whose slug isn't in the cache fall back to a deterministic hash so
/// dynamic URLs (`user-$messageId`, etc.) still pick a stable fixture.
///
/// Adding or replacing a fixture:
///   1. Drop the new PNG into `test/fixtures/avatars/`.
///   2. Add its slug to [_avatarSlugs].
///   3. (Recommended) declare the matching `User` in `sample_users.dart`.
class GoldenAvatarFixtures {
  GoldenAvatarFixtures._();

  /// Slugs of the Figma "User Photo" components, in the order they appear on
  /// the design canvas.
  static const _avatarSlugs = <String>[
    'amelia-moore',
    'charlotte-anderson',
    'elena-barros',
    'elisa-ramirez',
    'ethan-wilson',
    'james-garcia',
    'jason-thompson',
    'liam-johnson',
    'lina-park',
    'mateo-alvarez',
    'maya-ross',
    'mia-thompson',
    'noah-smith',
    'oliver-schmidt',
    'omar-jackson',
    'sophia-lee',
    'sophie-laurent',
    'wesley-lau',
  ];

  static const _fixturesDir = 'test/fixtures/avatars';

  static final _cache = <String, MemoryImage>{};
  static bool _ready = false;

  /// Loads every avatar PNG into memory. Call once before tests run;
  /// subsequent calls are no-ops.
  static Future<void> precompute() async {
    if (_ready) return;
    for (final slug in _avatarSlugs) {
      final bytes = await File('$_fixturesDir/$slug.png').readAsBytes();
      _cache[slug] = MemoryImage(Uint8List.fromList(bytes));
    }
    _ready = true;
  }

  /// Returns the cached [ImageProvider] for [url]. Resolves by slug when the
  /// URL's last path segment matches a known fixture; otherwise falls back to
  /// a deterministic pick from the pool. [precompute] must have completed
  /// first.
  static ImageProvider providerFor(String url) {
    if (!_ready) {
      throw StateError(
        'GoldenAvatarFixtures.precompute() must be awaited before use.',
      );
    }
    final exact = _cache[_slugFromUrl(url)];
    if (exact != null) return exact;
    final fallback = _avatarSlugs[url.hashCode.abs() % _avatarSlugs.length];
    return _cache[fallback]!;
  }

  static String _slugFromUrl(String url) {
    final segments = Uri.tryParse(url)?.pathSegments;
    if (segments == null || segments.isEmpty) return '';
    final last = segments.last;
    return last.endsWith('.png') ? last.substring(0, last.length - 4) : last;
  }
}

/// [StreamComponentBuilder] that renders every network image as a
/// deterministic fixture from [GoldenAvatarFixtures].
Widget goldenNetworkImageBuilder(
  BuildContext context,
  StreamNetworkImageProps props,
) {
  return Image(
    image: GoldenAvatarFixtures.providerFor(props.url),
    width: props.width,
    height: props.height,
    fit: props.fit,
    alignment: props.alignment,
    color: props.color,
    colorBlendMode: props.colorBlendMode,
    filterQuality: props.filterQuality,
  );
}
