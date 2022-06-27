import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// {@template streamGradientAvatar}
/// Fallback user avatar with a polygon gradient overlaid with text
/// {@endtemplate}
class StreamGradientAvatar extends StatefulWidget {
  /// {@macro streamGradientAvatar}
  const StreamGradientAvatar({
    super.key,
    required this.name,
    required this.userId,
  });

  /// Name of user to shorten and display
  final String name;

  /// ID of user to be used for key
  final String userId;

  @override
  _StreamGradientAvatarState createState() => _StreamGradientAvatarState();
}

class _StreamGradientAvatarState extends State<StreamGradientAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: PolygonGradientPainter(
            widget.userId,
            getShortenedName(widget.name),
            DefaultTextStyle.of(context).style.fontFamily ?? 'Roboto',
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  String getShortenedName(String name) {
    var parts = name.split(' ')..removeWhere((e) => e == '');

    if (parts.length > 2) {
      parts = parts.take(2).toList();
    }

    var result = '';

    for (var i = 0; i < parts.length; i++) {
      result = result + parts[i][0].toUpperCase();
    }

    return result;
  }
}

/// {@template polygonGradientPainter}
/// Painter for bg polygon gradient
/// {@endtemplate}
class PolygonGradientPainter extends CustomPainter {
  /// {@macro polygonGradientPainter}
  PolygonGradientPainter(
    this.userId,
    this.username,
    this.fontFamily,
  );

  /// Initial grid row count
  static const int rowCount = 5;

  /// Initial grid column count
  static const int columnCount = 5;

  /// User ID used for key
  String userId;

  /// User name to display
  String username;

  /// Font family to use
  String fontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final rowUnit = size.width / columnCount;
    final columnUnit = size.height / rowCount;
    final rand = Random(userId.length);

    final squares = <Offset4>[];
    final points = <Offset>{};
    final gradient = colorGradients[rand.nextInt(colorGradients.length)];

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < columnCount; j++) {
        final off1 = Offset(rowUnit * j, columnUnit * i);
        final off2 = Offset(rowUnit * (j + 1), columnUnit * i);
        final off3 = Offset(rowUnit * (j + 1), columnUnit * (i + 1));
        final off4 = Offset(rowUnit * j, columnUnit * (i + 1));

        points.addAll([off1, off2, off3, off4]);

        final pointsList = points.toList();

        final p1 = pointsList.indexOf(off1);
        final p2 = pointsList.indexOf(off2);
        final p3 = pointsList.indexOf(off3);
        final p4 = pointsList.indexOf(off4);

        squares.add(
          Offset4(p1, p2, p3, p4, i, j, rowCount, columnCount, gradient),
        );
      }
    }

    final list = transformPoints(points, size);
    squares.forEach((e) => e.draw(canvas, list));

    final smallerSide = size.width > size.height ? size.width : size.height;

    final textSize = smallerSide / 3;

    final dxShift = (username.length == 2 ? 1.45 : 0.9) * textSize / 2;
    final dyShift = (username.length == 2 ? 1.0 : 1.65) * textSize / 2;

    final fontSize = username.length == 2 ? textSize : textSize * 1.5;

    TextPainter(
      text: TextSpan(
        text: username,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: size.width)
      ..paint(
        canvas,
        Offset(
          (size.width / 2) - dxShift,
          (size.height / 2) - dyShift,
        ),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  /// Transforms initial grid into a polygon grid.
  List<Offset> transformPoints(Set<Offset> points, Size size) {
    final transformedList = <Offset>[];
    final orgList = points.toList();
    final rand = Random(userId.length);

    for (var i = 0; i < points.length; i++) {
      final orgDx = orgList[i].dx;
      final orgDy = orgList[i].dy;

      if (orgDx == 0 ||
          orgDy == 0 ||
          orgDx == size.width ||
          orgDy == size.height) {
        transformedList.add(Offset(orgDx, orgDy));
        continue;
      }

      final sign1 = rand.nextInt(2) == 1 ? 1 : -1;
      final sign2 = rand.nextInt(2) == 1 ? 1 : -1;

      final dx = sign1 * 0.6 * rand.nextInt(size.width ~/ columnCount);
      final dy = sign2 * 0.6 * rand.nextInt(size.height ~/ rowCount);

      transformedList.add(Offset(orgDx + dx, orgDy + dy));
    }

    return transformedList;
  }
}

/// {@template offset4}
/// Class for storing and drawing four points of a polygon.
/// {@endtemplate}
class Offset4 {
  /// {@macro offset4}
  Offset4(
    this.p1,
    this.p2,
    this.p3,
    this.p4,
    this.row,
    this.column,
    this.rowSize,
    this.colSize,
    this.gradient,
  );

  /// Point 1
  int p1;

  /// Point 2
  int p2;

  /// Point 3
  int p3;

  /// Point 4
  int p4;

  /// Position of polygon on grid
  int row;

  /// Position of polygon on grid
  int column;

  /// Max row size
  int rowSize;

  /// Max col size
  int colSize;

  /// Gradient to be applied to polygon
  List<Color> gradient;

  /// Draw the polygon on canvas
  void draw(Canvas canvas, List<Offset> points) {
    final paint = Paint()
      ..color = Color.fromARGB(
        255,
        Random().nextInt(255),
        Random().nextInt(255),
        Random().nextInt(255),
      )
      ..shader = ui.Gradient.linear(
        points[p1],
        points[p3],
        gradient,
      );

    final backgroundPath = Path()
      ..moveTo(points[p1].dx, points[p1].dy)
      ..lineTo(points[p2].dx, points[p2].dy)
      ..lineTo(points[p3].dx, points[p3].dy)
      ..lineTo(points[p4].dx, points[p4].dy)
      ..lineTo(points[p1].dx, points[p1].dy)
      ..close();

    canvas.drawPath(backgroundPath, paint);
  }
}

/// Gradient list for polygons
const colorGradients = [
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
