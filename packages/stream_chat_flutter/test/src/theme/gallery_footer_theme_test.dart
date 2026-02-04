import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('GalleryFooterThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamGalleryFooterThemeData(),
        const StreamGalleryFooterThemeData().copyWith());
    expect(const StreamGalleryFooterThemeData().hashCode,
        const StreamGalleryFooterThemeData().copyWith().hashCode);
  });

  test(
      '''Light GalleryFooterThemeData lerps completely to dark GalleryFooterThemeData''',
      () {
    expect(
        const StreamGalleryFooterThemeData().lerp(
            _galleryFooterThemeDataControl,
            _galleryFooterThemeDataControlDark,
            1),
        _galleryFooterThemeDataControlDark);
  });

  test(
      '''Light GalleryFooterThemeData lerps halfway to dark GalleryFooterThemeData''',
      () {
    expect(
      const StreamGalleryFooterThemeData().lerp(
        _galleryFooterThemeDataControl,
        _galleryFooterThemeDataControlDark,
        0.5,
      ),
      _galleryFooterThemeDataControlMidLerp,
      // TODO: Remove skip, once we drop support for flutter v3.24.0
      skip: true,
      reason: 'Currently failing in flutter v3.27.0 due to new color alpha',
    );
  });

  test(
      '''Dark GalleryFooterThemeData lerps completely to light GalleryFooterThemeData''',
      () {
    expect(
        const StreamGalleryFooterThemeData().lerp(
            _galleryFooterThemeDataControlDark,
            _galleryFooterThemeDataControl,
            1),
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final imageFooterTheme = StreamGalleryFooterTheme.of(_context);
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final imageFooterTheme = StreamGalleryFooterTheme.of(_context);
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
final _galleryFooterThemeDataControl = StreamGalleryFooterThemeData(
  backgroundColor: const StreamColorTheme.light().barsBg,
  shareIconColor: const StreamColorTheme.light().textHighEmphasis,
  titleTextStyle: const StreamTextTheme.light().headlineBold,
  gridIconButtonColor: const StreamColorTheme.light().textHighEmphasis,
  bottomSheetBackgroundColor: const StreamColorTheme.light().barsBg,
  bottomSheetBarrierColor: const StreamColorTheme.light().overlay,
  bottomSheetCloseIconColor: const StreamColorTheme.light().textHighEmphasis,
  bottomSheetPhotosTextStyle: const StreamTextTheme.light().headlineBold,
);

// Mid-lerp theme control
const _galleryFooterThemeDataControlMidLerp = StreamGalleryFooterThemeData(
  backgroundColor: Color(0xff88898a),
  shareIconColor: Color(0xff7f7f7f),
  titleTextStyle: TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  gridIconButtonColor: Color(0xff7f7f7f),
  bottomSheetBarrierColor: Color(0x4c000000),
  bottomSheetBackgroundColor: Color(0xff88898a),
  bottomSheetPhotosTextStyle: TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
  bottomSheetCloseIconColor: Color(0xff7f7f7f),
);

// Dark theme control
final _galleryFooterThemeDataControlDark = StreamGalleryFooterThemeData(
  backgroundColor: const StreamColorTheme.dark().barsBg,
  shareIconColor: const StreamColorTheme.dark().textHighEmphasis,
  titleTextStyle: const StreamTextTheme.dark().headlineBold,
  gridIconButtonColor: const StreamColorTheme.dark().textHighEmphasis,
  bottomSheetBackgroundColor: const StreamColorTheme.dark().barsBg,
  bottomSheetBarrierColor: const StreamColorTheme.dark().overlay,
  bottomSheetCloseIconColor: const StreamColorTheme.dark().textHighEmphasis,
  bottomSheetPhotosTextStyle: const StreamTextTheme.dark().headlineBold,
);
