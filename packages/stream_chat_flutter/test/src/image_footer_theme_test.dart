import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('ImageFooterThemeData copyWith, ==, hashCode basics', () {
    expect(
        const ImageFooterThemeData(), const ImageFooterThemeData().copyWith());
    expect(const ImageFooterThemeData().hashCode,
        const ImageFooterThemeData().copyWith().hashCode);
  });

  test(
      'Light ImageFooterThemeData lerps completely to dark ImageFooterThemeData',
      () {
    expect(
        const ImageFooterThemeData().lerp(
            _imageFooterThemeDataControl, _imageFooterThemeDataControlDark, 1),
        _imageFooterThemeDataControlDark);
  });

  test('Light ImageFooterThemeData lerps halfway to dark ImageFooterThemeData',
      () {
    expect(
        const ImageFooterThemeData().lerp(_imageFooterThemeDataControl,
            _imageFooterThemeDataControlDark, 0.5),
        _imageFooterThemeDataControlMidLerp);
  });

  test(
      'Dark ImageFooterThemeData lerps completely to light ImageFooterThemeData',
      () {
    expect(
        const ImageFooterThemeData().lerp(
            _imageFooterThemeDataControlDark, _imageFooterThemeDataControl, 1),
        _imageFooterThemeDataControl);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_imageFooterThemeDataControl.merge(_imageFooterThemeDataControlDark),
        _imageFooterThemeDataControlDark);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_imageFooterThemeDataControlDark.merge(_imageFooterThemeDataControl),
        _imageFooterThemeDataControl);
  });

  testWidgets(
      'Passing no ImageFooterThemeData returns default light theme values',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          child: child,
        ),
        home: Builder(
          builder: (context) {
            _context = context;
            return Scaffold(
              appBar: ImageFooter(
                message: Message(),
              ),
            );
          },
        ),
      ),
    );

    final imageFooterTheme = ImageFooterTheme.of(_context);
    expect(imageFooterTheme.backgroundColor,
        _imageFooterThemeDataControl.backgroundColor);
    expect(imageFooterTheme.shareIconColor,
        _imageFooterThemeDataControl.shareIconColor);
    expect(imageFooterTheme.titleTextStyle,
        _imageFooterThemeDataControl.titleTextStyle);
    expect(imageFooterTheme.gridIconButtonColor,
        _imageFooterThemeDataControl.gridIconButtonColor);
    expect(imageFooterTheme.bottomSheetBarrierColor,
        _imageFooterThemeDataControl.bottomSheetBarrierColor);
    expect(imageFooterTheme.bottomSheetBackgroundColor,
        _imageFooterThemeDataControl.bottomSheetBackgroundColor);
    expect(imageFooterTheme.bottomSheetCloseIconColor,
        _imageFooterThemeDataControl.bottomSheetCloseIconColor);
    expect(imageFooterTheme.bottomSheetPhotosTextStyle,
        _imageFooterThemeDataControl.bottomSheetPhotosTextStyle);
  });

  testWidgets(
      'Passing no ImageFooterThemeData returns default dark theme values',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockStreamChatClient(),
          streamChatThemeData: StreamChatThemeData.dark(),
          child: child,
        ),
        home: Builder(
          builder: (context) {
            _context = context;
            return Scaffold(
              appBar: ImageFooter(
                message: Message(),
              ),
            );
          },
        ),
      ),
    );

    final imageFooterTheme = ImageFooterTheme.of(_context);
    expect(imageFooterTheme.backgroundColor,
        _imageFooterThemeDataControlDark.backgroundColor);
    expect(imageFooterTheme.shareIconColor,
        _imageFooterThemeDataControlDark.shareIconColor);
    expect(imageFooterTheme.titleTextStyle,
        _imageFooterThemeDataControlDark.titleTextStyle);
    expect(imageFooterTheme.gridIconButtonColor,
        _imageFooterThemeDataControlDark.gridIconButtonColor);
    expect(imageFooterTheme.bottomSheetBarrierColor,
        _imageFooterThemeDataControlDark.bottomSheetBarrierColor);
    expect(imageFooterTheme.bottomSheetBackgroundColor,
        _imageFooterThemeDataControlDark.bottomSheetBackgroundColor);
    expect(imageFooterTheme.bottomSheetCloseIconColor,
        _imageFooterThemeDataControlDark.bottomSheetCloseIconColor);
    expect(imageFooterTheme.bottomSheetPhotosTextStyle,
        _imageFooterThemeDataControlDark.bottomSheetPhotosTextStyle);
  });
}

// Light theme control
final _imageFooterThemeDataControl = ImageFooterThemeData(
  backgroundColor: ColorTheme.light().barsBg,
  shareIconColor: ColorTheme.light().textHighEmphasis,
  titleTextStyle: TextTheme.light().headlineBold,
  gridIconButtonColor: ColorTheme.light().textHighEmphasis,
  bottomSheetBackgroundColor: ColorTheme.light().barsBg,
  bottomSheetBarrierColor: ColorTheme.light().overlay,
  bottomSheetCloseIconColor: ColorTheme.light().textHighEmphasis,
  bottomSheetPhotosTextStyle: TextTheme.light().headlineBold,
);

// Mid-lerp theme control
const _imageFooterThemeDataControlMidLerp = ImageFooterThemeData(
  backgroundColor: Color(0xff87898b),
  shareIconColor: Color(0xff7f7f7f),
  titleTextStyle: TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  gridIconButtonColor: Color(0xff7f7f7f),
  bottomSheetBarrierColor: Color(0x4c000000),
  bottomSheetBackgroundColor: Color(0xff87898b),
  bottomSheetPhotosTextStyle: TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  bottomSheetCloseIconColor: Color(0xff7f7f7f),
);

// Dark theme control
final _imageFooterThemeDataControlDark = ImageFooterThemeData(
  backgroundColor: ColorTheme.dark().barsBg,
  shareIconColor: ColorTheme.dark().textHighEmphasis,
  titleTextStyle: TextTheme.dark().headlineBold,
  gridIconButtonColor: ColorTheme.dark().textHighEmphasis,
  bottomSheetBackgroundColor: ColorTheme.dark().barsBg,
  bottomSheetBarrierColor: ColorTheme.dark().overlay,
  bottomSheetCloseIconColor: ColorTheme.dark().textHighEmphasis,
  bottomSheetPhotosTextStyle: TextTheme.dark().headlineBold,
);
