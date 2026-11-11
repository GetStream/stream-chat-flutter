// Imports the internal helper: a widget test can't set the device's time
// zone, so the offsets below can't be reached through the sheet.
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/schedule_message/schedule_message_time.dart';

void main() {
  test('timeZoneLabel names UTC GMT', () {
    expect(timeZoneLabel(Duration.zero), 'GMT');
  });

  test('timeZoneLabel names a whole-hour offset with its hours', () {
    expect(timeZoneLabel(const Duration(hours: 2)), 'GMT+2');
  });

  test('timeZoneLabel names a half-hour offset with its minutes', () {
    expect(timeZoneLabel(const Duration(hours: 5, minutes: 30)), 'GMT+5:30');
  });

  test('timeZoneLabel names an offset behind UTC with a minus', () {
    expect(timeZoneLabel(const Duration(hours: -3, minutes: -30)), 'GMT-3:30');
  });
}
