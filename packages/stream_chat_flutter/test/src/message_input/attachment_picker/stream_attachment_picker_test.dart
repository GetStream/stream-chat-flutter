import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('showStreamAttachmentPickerModalBottomSheet', () {
    group('attachmentPickerOptionsBuilder', () {
      testWidgets(
        'should call optionsBuilder with default options',
        (tester) async {
          var builderCalled = false;
          int? defaultOptionsCount;

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        optionsBuilder: (context, defaultOptions) {
                          builderCalled = true;
                          defaultOptionsCount = defaultOptions.length;
                          return defaultOptions;
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          expect(builderCalled, isTrue);
          expect(defaultOptionsCount, isNotNull);
          expect(defaultOptionsCount, greaterThan(0));
        },
      );

      testWidgets(
        'should allow filtering default options',
        (tester) async {
          int? defaultOptionsCount;

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        optionsBuilder: (context, defaultOptions) {
                          defaultOptionsCount = defaultOptions.length;
                          // Return only first option
                          return [defaultOptions.first];
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          final bottomSheet = tester.widget<StreamSystemAttachmentPickerBottomSheet>(
            find.byType(StreamSystemAttachmentPickerBottomSheet),
          );

          expect(bottomSheet.options.length, equals(1));
          expect(bottomSheet.options.length, lessThan(defaultOptionsCount!));
        },
      );

      testWidgets(
        'should allow adding custom options',
        (tester) async {
          int? defaultOptionsCount;
          const customOptionKey = 'custom-location';

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        optionsBuilder: (context, defaultOptions) {
                          defaultOptionsCount = defaultOptions.length;
                          return [
                            ...defaultOptions,
                            SystemAttachmentPickerOption(
                              key: customOptionKey,
                              icon: const Icon(Icons.location_on),
                              supportedTypes: [AttachmentPickerType.images],
                              title: 'Send Location',
                              onTap: (context, controller) async {},
                            ),
                          ];
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          final bottomSheet = tester.widget<StreamSystemAttachmentPickerBottomSheet>(
            find.byType(StreamSystemAttachmentPickerBottomSheet),
          );

          // Should have one more option than default
          expect(bottomSheet.options.length, equals(defaultOptionsCount! + 1));

          // Verify our custom option exists
          expect(
            bottomSheet.options.any((option) => option.key == customOptionKey),
            isTrue,
          );
        },
      );

      testWidgets(
        'should allow reordering options',
        (tester) async {
          String? firstDefaultKey;
          String? firstReversedKey;

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        optionsBuilder: (context, defaultOptions) {
                          firstDefaultKey = defaultOptions.first.key;
                          final reversed = defaultOptions.reversed.toList();
                          firstReversedKey = reversed.first.key;
                          return reversed;
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          // Verify first option changed after reversing
          expect(firstDefaultKey, isNotNull);
          expect(firstReversedKey, isNotNull);
          expect(firstDefaultKey, isNot(equals(firstReversedKey)));
        },
      );

      testWidgets(
        'should throw ArgumentError when wrong option types are provided',
        (tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        optionsBuilder: (context, defaultOptions) {
                          // Return tabbed option for system picker (wrong type)
                          return [
                            TabbedAttachmentPickerOption(
                              key: 'wrong',
                              icon: const Icon(Icons.error),
                              title: 'Wrong',
                              supportedTypes: [AttachmentPickerType.images],
                              optionViewBuilder: (context, controller) {
                                return const Text('Wrong');
                              },
                            ),
                          ];
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));

          // Should throw ArgumentError
          await tester.pumpAndSettle();

          expect(tester.takeException(), isA<ArgumentError>());
        },
      );
    });

    group('allowedTypes', () {
      testWidgets(
        'should filter options based on allowedTypes',
        (tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        allowedTypes: [AttachmentPickerType.images],
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          final bottomSheet = tester.widget<StreamSystemAttachmentPickerBottomSheet>(
            find.byType(StreamSystemAttachmentPickerBottomSheet),
          );

          // All options should support images
          expect(
            bottomSheet.options.every(
              (option) => option.supportedTypes.contains(AttachmentPickerType.images),
            ),
            isTrue,
          );
        },
      );

      testWidgets(
        'should work with optionsBuilder and allowedTypes together',
        (tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        allowedTypes: [
                          AttachmentPickerType.images,
                          AttachmentPickerType.videos,
                        ],
                        optionsBuilder: (context, defaultOptions) {
                          return defaultOptions;
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          expect(
            find.byType(StreamSystemAttachmentPickerBottomSheet),
            findsOneWidget,
          );
        },
      );
    });

    group('System picker with optionsBuilder', () {
      testWidgets(
        'should use optionsBuilder with system picker',
        (tester) async {
          var builderCalled = false;

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        useSystemAttachmentPicker: true,
                        optionsBuilder: (context, defaultOptions) {
                          builderCalled = true;
                          return defaultOptions;
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          expect(builderCalled, isTrue);
          expect(
            find.byType(StreamSystemAttachmentPickerBottomSheet),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'should allow adding custom system picker options',
        (tester) async {
          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showStreamAttachmentPickerModalBottomSheet(
                        context: context,
                        useSystemAttachmentPicker: true,
                        optionsBuilder: (context, defaultOptions) {
                          return [
                            ...defaultOptions,
                            SystemAttachmentPickerOption(
                              key: 'custom-upload',
                              icon: const Icon(Icons.cloud_upload),
                              title: 'Custom Upload',
                              supportedTypes: [AttachmentPickerType.files],
                              onTap: (context, controller) async {},
                            ),
                          ];
                        },
                      );
                    },
                    child: const Text('Show Picker'),
                  );
                },
              ),
            ),
          );

          await tester.tap(find.text('Show Picker'));
          await tester.pumpAndSettle();

          expect(find.text('Custom Upload'), findsOneWidget);
        },
      );
    });
  });
}

Widget _wrapWithStreamChatApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: widget,
          );
        },
      ),
    ),
  );
}
