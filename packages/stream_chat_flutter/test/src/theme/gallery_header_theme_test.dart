import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('GalleryHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamGalleryHeaderThemeData(), const StreamGalleryHeaderThemeData().copyWith());
    expect(const StreamGalleryHeaderThemeData().hashCode, const StreamGalleryHeaderThemeData().copyWith().hashCode);
  });

  test('''Light GalleryHeaderThemeData lerps completely to dark GalleryHeaderThemeData''', () {
    expect(
      const StreamGalleryHeaderThemeData().lerp(_galleryHeaderThemeDataControl, _galleryHeaderThemeDataDarkControl, 1),
      _galleryHeaderThemeDataDarkControl,
    );
  });

  test('''Light GalleryHeaderThemeData lerps halfway to dark GalleryHeaderThemeData''', () {
    expect(
      const StreamGalleryHeaderThemeData().lerp(
        _galleryHeaderThemeDataControl,
        _galleryHeaderThemeDataDarkControl,
        0.5,
      ),
      _galleryHeaderThemeDataHalfLerpControl,
      // TODO: Remove skip, once we drop support for flutter v3.24.0
      skip: true,
      reason: 'Currently failing in flutter v3.27.0 due to new color alpha',
    );
  });

  test('''Dark GalleryHeaderThemeData lerps completely to light GalleryHeaderThemeData''', () {
    expect(
      const StreamGalleryHeaderThemeData().lerp(_galleryHeaderThemeDataDarkControl, _galleryHeaderThemeDataControl, 1),
      _galleryHeaderThemeDataControl,
    );
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
      _galleryHeaderThemeDataControl.merge(_galleryHeaderThemeDataDarkControl),
      _galleryHeaderThemeDataDarkControl,
    );
  });

  testWidgets('Passing no GalleryHeaderThemeData returns default light theme values', (WidgetTester tester) async {
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

    final imageHeaderTheme = StreamGalleryHeaderTheme.of(_context);
    expect(imageHeaderTheme.closeButtonColor, _galleryHeaderThemeDataControl.closeButtonColor);
    expect(imageHeaderTheme.backgroundColor, _galleryHeaderThemeDataControl.backgroundColor);
    expect(imageHeaderTheme.iconMenuPointColor, _galleryHeaderThemeDataControl.iconMenuPointColor);
    expect(imageHeaderTheme.titleTextStyle, _galleryHeaderThemeDataControl.titleTextStyle);
    expect(imageHeaderTheme.subtitleTextStyle, _galleryHeaderThemeDataControl.subtitleTextStyle);
    expect(imageHeaderTheme.bottomSheetBarrierColor, _galleryHeaderThemeDataControl.bottomSheetBarrierColor);
  });

  testWidgets('Passing no GalleryHeaderThemeData returns default dark theme values', (WidgetTester tester) async {
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

    final imageHeaderTheme = StreamGalleryHeaderTheme.of(_context);
    expect(imageHeaderTheme.closeButtonColor, _galleryHeaderThemeDataDarkControl.closeButtonColor);
    expect(imageHeaderTheme.backgroundColor, _galleryHeaderThemeDataDarkControl.backgroundColor);
    expect(imageHeaderTheme.iconMenuPointColor, _galleryHeaderThemeDataDarkControl.iconMenuPointColor);
    expect(imageHeaderTheme.titleTextStyle, _galleryHeaderThemeDataDarkControl.titleTextStyle);
    expect(imageHeaderTheme.subtitleTextStyle, _galleryHeaderThemeDataDarkControl.subtitleTextStyle);
    expect(imageHeaderTheme.bottomSheetBarrierColor, _galleryHeaderThemeDataDarkControl.bottomSheetBarrierColor);
  });
}

// Light theme test control.
const _galleryHeaderThemeDataControl = StreamGalleryHeaderThemeData(
  closeButtonColor: Color(0xff000000),
  backgroundColor: Color(0xffffffff),
  iconMenuPointColor: Color(0xff000000),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  subtitleTextStyle: null,
  bottomSheetBarrierColor: Color.fromRGBO(0, 0, 0, 0.2),
);

// Light theme test control.
const _galleryHeaderThemeDataHalfLerpControl = StreamGalleryHeaderThemeData(
  closeButtonColor: Color(0xff7f7f7f),
  backgroundColor: Color(0xff88898a),
  iconMenuPointColor: Color(0xff7f7f7f),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xff7f7f7f),
  ),
  subtitleTextStyle: null,
  bottomSheetBarrierColor: Color(0x4c000000),
);

// Dark theme test control.
const _galleryHeaderThemeDataDarkControl = StreamGalleryHeaderThemeData(
  closeButtonColor: Color(0xffffffff),
  backgroundColor: Color(0xff121416),
  iconMenuPointColor: Color(0xffffffff),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
  subtitleTextStyle: null,
  bottomSheetBarrierColor: Color.fromRGBO(0, 0, 0, 0.4),
);
