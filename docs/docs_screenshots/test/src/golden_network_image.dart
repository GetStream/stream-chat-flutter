import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// Avatar fixtures sourced from Stream's Chat SDK Design System (Figma node
/// `2867:55922`, "User Photo"). Each PNG is an 80×80 crop of one of the 18
/// named sample users; the file name matches the Figma component name in
/// kebab-case (e.g. `Amelia Moore` → `amelia-moore.png`).
///
/// At test time, every `props.url` passed to [goldenNetworkImageBuilder] is
/// hashed into this list, so a given URL maps to the same person across
/// every snapshot.
///
/// To add or replace avatars, drop a new PNG into
/// `test/fixtures/avatars/` and add its slug to [_avatarSlugs].
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

  static final _cache = <int, MemoryImage>{};
  static bool _ready = false;

  /// Loads every avatar PNG into memory. Call once before tests run;
  /// subsequent calls are no-ops.
  static Future<void> precompute() async {
    if (_ready) return;
    for (var i = 0; i < _avatarSlugs.length; i++) {
      final bytes = await File('$_fixturesDir/${_avatarSlugs[i]}.png').readAsBytes();
      _cache[i] = MemoryImage(Uint8List.fromList(bytes));
    }
    _ready = true;
  }

  /// Returns the cached [ImageProvider] for [url]. [precompute] must have
  /// completed first.
  static ImageProvider providerFor(String url) {
    final image = _cache[url.hashCode.abs() % _avatarSlugs.length];
    if (image == null) {
      throw StateError(
        'GoldenAvatarFixtures.precompute() must be awaited before use.',
      );
    }
    return image;
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
