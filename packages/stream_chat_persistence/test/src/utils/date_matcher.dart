import 'package:test/test.dart';
import 'package:meta/meta.dart';

Matcher isSameDateAs(DateTime targetDate) =>
    _IsSameDateAs(targetDate: targetDate);

class _IsSameDateAs extends Matcher {
  const _IsSameDateAs({
    @required this.targetDate,
  }) : assert(targetDate != null, '');

  final DateTime targetDate;

  @override
  bool matches(covariant DateTime date, Map matchState) =>
      date.year == targetDate.year &&
      date.month == targetDate.month &&
      date.day == targetDate.day &&
      date.hour == targetDate.hour &&
      date.minute == targetDate.minute &&
      date.second == targetDate.second;

  @override
  Description describe(Description description) =>
      description.add('is same date as $targetDate');
}
