import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';

extension SvgIconWidgetFinder on CommonFinders {
  /// Asserts that the SvgIcon widget is found.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// expect(find.bySvgIcon(StreamSvgIcons.mic), findsOneWidget);
  /// ```
  Finder bySvgIcon(SvgIconData icon) => _SvgIconWidgetFinder(icon);
}

class _SvgIconWidgetFinder extends MatchFinder {
  _SvgIconWidgetFinder(this.icon);

  final SvgIconData icon;

  @override
  String get description => 'SvgIcon "$icon"';

  @override
  bool matches(Element candidate) {
    final widget = candidate.widget;
    return widget is SvgIcon && widget.icon == icon;
  }
}
