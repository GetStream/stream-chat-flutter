import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GradientAvatar extends StatefulWidget {
  final String name;
  final String userId;

  const GradientAvatar({
    Key? key,
    required this.name,
    required this.userId,
  }) : super(key: key);

  @override
  _GradientAvatarState createState() => _GradientAvatarState();
}

class _GradientAvatarState extends State<GradientAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RepaintBoundary(
        child: Container(
          width: 100.0,
          height: 100.0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: DemoPainter(widget.userId),
                child: SizedBox.expand(),
              ),
              FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Text(
                      getShortenedName(widget.name),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 112.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getShortenedName(String name) {
    List<String> parts = name.split(' ')..removeWhere((e) => e == '');

    if (parts.length > 2) {
      parts = parts.take(2).toList();
    }

    String result = '';

    for (int i = 0; i < parts.length; i++) {
      result = result + parts[i][0];
    }

    return result;
  }
}

class DemoPainter extends CustomPainter {
  static const int rowCount = 5;
  static const int columnCount = 5;

  String userId;

  DemoPainter(this.userId);

  @override
  void paint(Canvas canvas, Size size) {
    var rowUnit = size.width / columnCount;
    var columnUnit = size.height / rowCount;
    var rand = Random(userId.length);

    List<Offset4> squares = [];
    Set<Offset> points = {};
    List<Color> gradient = colorGradients[rand.nextInt(colorGradients.length)];

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        var off1 = Offset(rowUnit * j, columnUnit * i);
        var off2 = Offset(rowUnit * (j + 1), columnUnit * i);
        var off3 = Offset(rowUnit * (j + 1), columnUnit * (i + 1));
        var off4 = Offset(rowUnit * j, columnUnit * (i + 1));

        points.addAll([off1, off2, off3, off4]);

        var p1 = points.toList().indexOf(off1);
        var p2 = points.toList().indexOf(off2);
        var p3 = points.toList().indexOf(off3);
        var p4 = points.toList().indexOf(off4);

        squares.add(
            Offset4(p1, p2, p3, p4, i, j, rowCount, columnCount, gradient));
      }
    }

    var list = transformPoints(points, size);
    squares.forEach((e) => e.draw(canvas, list));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  List<Offset> transformPoints(Set<Offset> points, Size size) {
    List<Offset> transformedList = [];
    var orgList = points.toList();
    var rand = Random(userId.length);

    for (int i = 0; i < points.length; i++) {
      var orgDx = orgList[i].dx;
      var orgDy = orgList[i].dy;

      if (orgDx == 0 ||
          orgDy == 0 ||
          orgDx == size.width ||
          orgDy == size.height) {
        transformedList.add(Offset(orgDx, orgDy));
        continue;
      }

      int sign1 = rand.nextInt(2) == 1 ? 1 : -1;
      int sign2 = rand.nextInt(2) == 1 ? 1 : -1;

      double dx = 0.6 * sign1 * rand.nextInt(size.width ~/ columnCount);
      double dy = 0.6 * sign2 * rand.nextInt(size.height ~/ rowCount);

      transformedList.add(Offset(orgDx + dx, orgDy + dy));
    }

    return transformedList;
  }
}

class Offset4 {
  int p1;
  int p2;
  int p3;
  int p4;
  int row;
  int column;
  int rowSize;
  int colSize;
  List<Color> gradient;

  Offset4(this.p1, this.p2, this.p3, this.p4, this.row, this.column,
      this.rowSize, this.colSize, this.gradient);

  void draw(Canvas canvas, List<Offset> points) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, Random().nextInt(255),
          Random().nextInt(255), Random().nextInt(255))
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
