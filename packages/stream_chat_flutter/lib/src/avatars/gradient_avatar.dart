import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';

/// Fallback avatar with a polygon gradient background and initials overlay.
///
/// Creates a deterministic gradient avatar based on the user's [userId] that
/// displays user initials over a colorful jittered polygon background. Each
/// user gets a consistent gradient color and jitter pattern based on their ID.
///
/// The avatar uses a jittered polygon grid to create visual variety while
/// maintaining deterministic appearance for the same user across sessions.
///
/// Example usage:
/// ```dart
/// StreamGradientAvatar(
///   name: 'John Doe',
///   userId: 'user-123',
///   jitterIntensity: 0.6,
/// )
/// ```
class StreamGradientAvatar extends StatelessWidget {
  /// Creates a gradient avatar with the specified [name] and [userId].
  ///
  /// The [jitterIntensity] controls how much randomness is applied to the
  /// polygon grid, where 0.0 creates a perfectly regular grid and 1.0 creates
  /// maximum randomness.
  const StreamGradientAvatar({
    super.key,
    required this.name,
    required this.userId,
    this.jitterIntensity = 0.4,
  });

  /// The display name used to generate initials for the avatar.
  final String name;

  /// The unique identifier used to generate consistent colors and jitter.
  final String userId;

  /// The intensity of polygon jitter applied to the background.
  ///
  /// Must be between 0.0 (no jitter) and 1.0 (maximum jitter).
  /// Defaults to 0.4 for moderate visual variety.
  final double jitterIntensity;

  @override
  Widget build(BuildContext context) {
    final random = Random(userId.hashCode);
    final gradient = _palettes[random.nextInt(_palettes.length)];
    final jitter = Jitter.custom(random: random, intensity: jitterIntensity);

    return RepaintBoundary(
      key: Key(userId),
      child: CustomPaint(
        painter: PolygonGradientPainter(
          jitter: jitter,
          gradient: gradient,
        ),
        child: Center(child: _Initials(username: name)),
      ),
    );
  }
}

/// Displays user initials with responsive sizing over gradient backgrounds.
///
/// Extracts and displays up to two initials from the username with automatic
/// font sizing based on the available space and number of characters.
class _Initials extends StatelessWidget {
  /// Creates an initials widget for the given [username].
  const _Initials({
    required this.username,
  });

  /// The username from which to extract and display initials.
  final String username;

  @override
  Widget build(BuildContext context) {
    final initials = username.initials ?? '?';

    return LayoutBuilder(builder: (context, constraints) {
      final side = min(constraints.maxWidth, constraints.maxHeight);
      final fontSize = initials.length == 2 ? side / 3 : side / 2;

      return Text(
        initials,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          // ignore: deprecated_member_use
          color: Colors.white.withValues(alpha: 0.7),
        ),
      );
    });
  }
}

/// Custom painter that draws a jittered polygon grid with gradient fills.
///
/// Creates a grid of polygon cells with optional jitter displacement and fills
/// each cell with a linear gradient. The grid layout is customizable through
/// [rows] and [columns], while visual variety is controlled by the [jitter]
/// configuration.
///
/// Each polygon cell is filled with a linear gradient that creates smooth
/// color transitions across the entire painted area.
class PolygonGradientPainter extends CustomPainter {
  /// Creates a polygon gradient painter with the specified configuration.
  ///
  /// The [jitter] controls the random displacement applied to interior grid
  /// points, while [gradient] defines the colors used for filling the polygon
  /// cells.
  PolygonGradientPainter({
    this.rows = 4,
    this.columns = 4,
    required this.jitter,
    required this.gradient,
  });

  /// The number of rows in the polygon grid.
  final int rows;

  /// The number of columns in the polygon grid.
  final int columns;

  /// The jitter configuration for displacing interior grid points.
  final Jitter jitter;

  /// The gradient colors used to fill each polygon cell.
  final List<Color> gradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final cols1 = columns + 1;
    final rows1 = rows + 1;
    final cellW = size.width / columns;
    final cellH = size.height / rows;

    final maxDx = cellW;
    final maxDy = cellH;

    // Build jittered grid points
    final points = List<Offset>.filled(cols1 * rows1, Offset.zero);
    for (var r = 0; r < rows1; r++) {
      final y = r * cellH;
      final rowBase = r * cols1;
      for (var c = 0; c < cols1; c++) {
        final x = c * cellW;
        final isBorder = r == 0 || c == 0 || r == rows1 - 1 || c == cols1 - 1;

        if (isBorder) {
          points[rowBase + c] = Offset(x, y);
        } else {
          points[rowBase + c] = jitter.applyTo(Offset(x, y), maxDx, maxDy);
        }
      }
    }

    // Build cells from jittered points and draw them
    for (var r = 0; r < rows; r++) {
      final base = r * cols1;
      final next = (r + 1) * cols1;
      for (var c = 0; c < columns; c++) {
        final a = points[base + c];
        final b = points[base + c + 1];
        final d = points[next + c];
        final e = points[next + c + 1];

        PolygonCell(a, b, e, d).paint(canvas, gradient);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PolygonGradientPainter old) =>
      old.rows != rows ||
      old.columns != columns ||
      old.jitter.intensity != jitter.intensity ||
      !const ListEquality().equals(old.gradient, gradient);
}

/// A quadrilateral polygon cell defined by four corner points.
///
/// Represents a single cell in the jittered polygon grid that can paint itself
/// with a linear gradient fill. The cell is defined by four corner points that
/// form a quadrilateral shape.
class PolygonCell {
  /// Creates a polygon cell with the specified corner points.
  ///
  /// Points should be ordered to form a proper quadrilateral shape.
  const PolygonCell(
    this.pointA,
    this.pointB,
    this.pointC,
    this.pointD,
  );

  /// The first corner point of the polygon cell.
  final Offset pointA;

  /// The second corner point of the polygon cell.
  final Offset pointB;

  /// The third corner point of the polygon cell.
  final Offset pointC;

  /// The fourth corner point of the polygon cell.
  final Offset pointD;

  /// Paints this polygon cell on the [canvas] with the specified [gradient].
  ///
  /// Creates a linear gradient shader from [pointA] to [pointC] and fills
  /// the quadrilateral path formed by all four corner points.
  void paint(
    Canvas canvas,
    List<Color> gradient,
  ) {
    final shader = ui.Gradient.linear(pointA, pointC, gradient);
    final paint = Paint()..shader = shader;

    final path = Path()
      ..moveTo(pointA.dx, pointA.dy)
      ..lineTo(pointB.dx, pointB.dy)
      ..lineTo(pointC.dx, pointC.dy)
      ..lineTo(pointD.dx, pointD.dy)
      ..close();

    canvas.drawPath(path, paint);
  }
}

/// Predefined gradient color palettes for avatar backgrounds.
///
/// Contains a curated collection of two-color gradients that provide visually
/// appealing and accessible color combinations for user avatars. Each palette
/// consists of two colors that create smooth linear gradients.
const _palettes = <List<Color>>[
  [Color(0xffffafbd), Color(0xffffc3a0)],
  [Color(0xff2193b0), Color(0xff6dd5ed)],
  [Color(0xffcc2b5e), Color(0xff753a88)],
  [Color(0xffee9ca7), Color(0xffffdde1)],
  [Color(0xff42275a), Color(0xff734b6d)],
  [Color(0xffde6262), Color(0xffffb88c)],
  [Color(0xff56ab2f), Color(0xffa8e063)],
  [Color(0xff614385), Color(0xff516395)],
  [Color(0xffeacda3), Color(0xffd6ae7b)],
  [Color(0xff02aab0), Color(0xff00cdac)],
];
