import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockStreamChatClient extends Mock implements StreamChatClient {}

void main() {
  test('ImageHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(
        const ImageHeaderThemeData(), const ImageHeaderThemeData().copyWith());
    expect(const ImageHeaderThemeData().hashCode,
        const ImageHeaderThemeData().copyWith().hashCode);
  });

  testWidgets(
      'Passing no ImageHeaderThemeData returns default light theme values',
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
              appBar: ImageHeader(
                message: Message(),
              ),
            );
          },
        ),
      ),
    );

    final imageHeaderTheme = ImageHeaderTheme.of(_context);
    expect(imageHeaderTheme.closeButtonColor,
        _imageHeaderThemeDataControl.closeButtonColor);
    expect(imageHeaderTheme.backgroundColor,
        _imageHeaderThemeDataControl.backgroundColor);
    expect(imageHeaderTheme.iconMenuPointColor,
        _imageHeaderThemeDataControl.iconMenuPointColor);
    expect(imageHeaderTheme.titleTextStyle,
        _imageHeaderThemeDataControl.titleTextStyle);
    expect(imageHeaderTheme.subtitleTextStyle,
        _imageHeaderThemeDataControl.subtitleTextStyle);
    expect(imageHeaderTheme.bottomSheetBarrierColor,
        _imageHeaderThemeDataControl.bottomSheetBarrierColor);
  });

  testWidgets(
      'Passing no ImageHeaderThemeData returns default dark theme values',
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
                  appBar: ImageHeader(
                    message: Message(),
                  ),
                );
              },
            ),
          ),
        );

        final imageHeaderTheme = ImageHeaderTheme.of(_context);
        expect(imageHeaderTheme.closeButtonColor,
            _imageHeaderThemeDataDarkControl.closeButtonColor);
        expect(imageHeaderTheme.backgroundColor,
            _imageHeaderThemeDataDarkControl.backgroundColor);
        expect(imageHeaderTheme.iconMenuPointColor,
            _imageHeaderThemeDataDarkControl.iconMenuPointColor);
        expect(imageHeaderTheme.titleTextStyle,
            _imageHeaderThemeDataDarkControl.titleTextStyle);
        expect(imageHeaderTheme.subtitleTextStyle,
            _imageHeaderThemeDataDarkControl.subtitleTextStyle);
        expect(imageHeaderTheme.bottomSheetBarrierColor,
            _imageHeaderThemeDataDarkControl.bottomSheetBarrierColor);
      });
}

// Light theme test control.
//
// Test default ImageHeaderThemeData values against this control.
final _imageHeaderThemeDataControl = ImageHeaderThemeData(
  closeButtonColor: const Color(0xff000000),
  backgroundColor: const Color(0xffffffff),
  iconMenuPointColor: const Color(0xff000000),
  titleTextStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
  subtitleTextStyle: const TextStyle(
    fontSize: 12,
    color: Colors.black,
  ).copyWith(
    color: const Color(0xff7A7A7A),
  ),
  bottomSheetBarrierColor: const Color.fromRGBO(0, 0, 0, 0.2),
);

// Light theme test control.
//
// Test default ImageHeaderThemeData values against this control.
final _imageHeaderThemeDataDarkControl = ImageHeaderThemeData(
  closeButtonColor: const Color(0xffffffff),
  backgroundColor: const Color(0xff101418),
  iconMenuPointColor: const Color(0xffffffff),
  titleTextStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  subtitleTextStyle: const TextStyle(
    fontSize: 12,
    color: Colors.white,
  ).copyWith(
    color: const Color(0xff7A7A7A),
  ),
  bottomSheetBarrierColor: const Color.fromRGBO(0, 0, 0, 0.4),
);
