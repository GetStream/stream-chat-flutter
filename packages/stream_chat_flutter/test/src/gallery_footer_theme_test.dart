import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('GalleryFooterThemeData copyWith, ==, hashCode basics', () {
    expect(const GalleryFooterThemeData(),
        const GalleryFooterThemeData().copyWith());
    expect(const GalleryFooterThemeData().hashCode,
        const GalleryFooterThemeData().copyWith().hashCode);
  });

  test(
      '''Light GalleryFooterThemeData lerps completely to dark GalleryFooterThemeData''',
      () {
    expect(
        const GalleryFooterThemeData().lerp(_galleryFooterThemeDataControl,
            _galleryFooterThemeDataControlDark, 1),
        _galleryFooterThemeDataControlDark);
  });

  test(
      '''Light GalleryFooterThemeData lerps halfway to dark GalleryFooterThemeData''',
      () {
    expect(
        const GalleryFooterThemeData().lerp(_galleryFooterThemeDataControl,
            _galleryFooterThemeDataControlDark, 0.5),
        _galleryFooterThemeDataControlMidLerp);
  });

  test(
      '''Dark GalleryFooterThemeData lerps completely to light GalleryFooterThemeData''',
      () {
    expect(
        const GalleryFooterThemeData().lerp(_galleryFooterThemeDataControlDark,
            _galleryFooterThemeDataControl, 1),
        _galleryFooterThemeDataControl);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _galleryFooterThemeDataControl
            .merge(_galleryFooterThemeDataControlDark),
        _galleryFooterThemeDataControlDark);
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _galleryFooterThemeDataControlDark
            .merge(_galleryFooterThemeDataControl),
        _galleryFooterThemeDataControl);
  });

  testWidgets(
      'Passing no GalleryFooterThemeData returns default light theme values',
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
              appBar: GalleryFooter(
                message: Message(),
              ),
            );
          },
        ),
      ),
    );

    final imageFooterTheme = GalleryFooterTheme.of(_context);
    expect(imageFooterTheme.backgroundColor,
        _galleryFooterThemeDataControl.backgroundColor);
    expect(imageFooterTheme.shareIconColor,
        _galleryFooterThemeDataControl.shareIconColor);
    expect(imageFooterTheme.titleTextStyle,
        _galleryFooterThemeDataControl.titleTextStyle);
    expect(imageFooterTheme.gridIconButtonColor,
        _galleryFooterThemeDataControl.gridIconButtonColor);
    expect(imageFooterTheme.bottomSheetBarrierColor,
        _galleryFooterThemeDataControl.bottomSheetBarrierColor);
    expect(imageFooterTheme.bottomSheetBackgroundColor,
        _galleryFooterThemeDataControl.bottomSheetBackgroundColor);
    expect(imageFooterTheme.bottomSheetCloseIconColor,
        _galleryFooterThemeDataControl.bottomSheetCloseIconColor);
    expect(imageFooterTheme.bottomSheetPhotosTextStyle,
        _galleryFooterThemeDataControl.bottomSheetPhotosTextStyle);
  });

  testWidgets(
      'Passing no GalleryFooterThemeData returns default dark theme values',
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
              appBar: GalleryFooter(
                message: Message(),
              ),
            );
          },
        ),
      ),
    );

    final imageFooterTheme = GalleryFooterTheme.of(_context);
    expect(imageFooterTheme.backgroundColor,
        _galleryFooterThemeDataControlDark.backgroundColor);
    expect(imageFooterTheme.shareIconColor,
        _galleryFooterThemeDataControlDark.shareIconColor);
    expect(imageFooterTheme.titleTextStyle,
        _galleryFooterThemeDataControlDark.titleTextStyle);
    expect(imageFooterTheme.gridIconButtonColor,
        _galleryFooterThemeDataControlDark.gridIconButtonColor);
    expect(imageFooterTheme.bottomSheetBarrierColor,
        _galleryFooterThemeDataControlDark.bottomSheetBarrierColor);
    expect(imageFooterTheme.bottomSheetBackgroundColor,
        _galleryFooterThemeDataControlDark.bottomSheetBackgroundColor);
    expect(imageFooterTheme.bottomSheetCloseIconColor,
        _galleryFooterThemeDataControlDark.bottomSheetCloseIconColor);
    expect(imageFooterTheme.bottomSheetPhotosTextStyle,
        _galleryFooterThemeDataControlDark.bottomSheetPhotosTextStyle);
  });
}

// Light theme control
final _galleryFooterThemeDataControl = GalleryFooterThemeData(
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
const _galleryFooterThemeDataControlMidLerp = GalleryFooterThemeData(
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
final _galleryFooterThemeDataControlDark = GalleryFooterThemeData(
  backgroundColor: ColorTheme.dark().barsBg,
  shareIconColor: ColorTheme.dark().textHighEmphasis,
  titleTextStyle: TextTheme.dark().headlineBold,
  gridIconButtonColor: ColorTheme.dark().textHighEmphasis,
  bottomSheetBackgroundColor: ColorTheme.dark().barsBg,
  bottomSheetBarrierColor: ColorTheme.dark().overlay,
  bottomSheetCloseIconColor: ColorTheme.dark().textHighEmphasis,
  bottomSheetPhotosTextStyle: TextTheme.dark().headlineBold,
);
