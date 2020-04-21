import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// It shows a date divider depending on the date difference
class DateDivider extends StatelessWidget {
  const DateDivider({
    Key key,
    @required this.nextMessage,
    @required this.messageWidget,
  }) : super(key: key);

  final Message nextMessage;
  final Widget messageWidget;

  @override
  Widget build(BuildContext context) {
    final divider = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Divider(),
      ),
    );

    final createdAt = Jiffy(nextMessage.createdAt.toLocal());
    final now = DateTime.now();
    final hourInfo = createdAt.format('h:mm a');

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
      dayInfo = createdAt.format('dd/MM').toUpperCase();
    } else {
      dayInfo = createdAt.format('dd/MM/yyyy').toUpperCase();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        messageWidget,
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              divider,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: dayInfo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' AT'),
                      TextSpan(text: ' $hourInfo'),
                    ],
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        Theme.of(context).textTheme.title.color.withOpacity(.5),
                  ),
                ),
              ),
              divider,
            ],
          ),
        ),
      ],
    );
  }
}
