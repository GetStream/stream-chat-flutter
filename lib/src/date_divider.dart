import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

/// It shows a date divider depending on the date difference
class DateDivider extends StatelessWidget {
  final DateTime dateTime;

  const DateDivider({
    Key key,
    @required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createdAt = Jiffy(dateTime);
    final now = DateTime.now();

    String dayInfo;
    if (Jiffy(createdAt).isSame(now, Units.DAY)) {
      dayInfo = 'TODAY';
    } else if (Jiffy(createdAt)
        .isSame(now.subtract(Duration(days: 1)), Units.DAY)) {
      dayInfo = 'YESTERDAY';
    } else if (Jiffy(createdAt).isAfter(
      now.subtract(Duration(days: 7)),
      Units.DAY,
    )) {
      dayInfo = createdAt.format('EEEE').toUpperCase();
    } else if (Jiffy(createdAt).isAfter(
      Jiffy(now).subtract(years: 1),
      Units.DAY,
    )) {
      dayInfo = createdAt.format('MMMM d').toUpperCase();
    } else {
      dayInfo = createdAt.format('MMMM d').toUpperCase();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Text(
          dayInfo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
