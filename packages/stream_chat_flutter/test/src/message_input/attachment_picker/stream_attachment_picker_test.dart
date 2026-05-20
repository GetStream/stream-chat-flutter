import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('tabbedAttachmentPickerBuilder', () {
    group('optionsBuilder', () {
      testWidgets(
        'should call optionsBuilder with default options',
        (tester) async {
          var builderCalled = false;
          int? defaultOptionsCount;

          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: tabbedAttachmentPickerBuilder(
                      context: context,
                      controller: controller,
                      optionsBuilder: (context, defaultOptions) {
                        builderCalled = true;
                        defaultOptionsCount = defaultOptions.length;
                        return defaultOptions;
                      },
                    ),
                  );
                },
              ),
            ),
          );

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

          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: tabbedAttachmentPickerBuilder(
                      context: context,
                      controller: controller,
                      optionsBuilder: (context, defaultOptions) {
                        defaultOptionsCount = defaultOptions.length;
                        return [defaultOptions.first];
                      },
                    ),
                  );
                },
              ),
            ),
          );

          await tester.pumpAndSettle();

          final picker = tester.widget<StreamTabbedAttachmentPicker>(
            find.byType(StreamTabbedAttachmentPicker),
          );

          expect(picker.options.length, equals(1));
          expect(picker.options.length, lessThan(defaultOptionsCount!));
        },
      );

      testWidgets(
        'should throw ArgumentError when wrong option types are provided',
        (tester) async {
          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: tabbedAttachmentPickerBuilder(
                      context: context,
                      controller: controller,
                      optionsBuilder: (context, defaultOptions) {
                        return [
                          SystemAttachmentPickerOption(
                            key: 'wrong',
                            icon: Icons.error,
                            title: 'Wrong',
                            supportedTypes: [AttachmentPickerType.images],
                            onTap: (context, controller) async {},
                          ),
                        ];
                      },
                    ),
                  );
                },
              ),
            ),
          );

          expect(tester.takeException(), isA<ArgumentError>());
        },
      );
    });

    group('allowedTypes', () {
      testWidgets(
        'should filter options based on allowedTypes',
        (tester) async {
          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: tabbedAttachmentPickerBuilder(
                      context: context,
                      controller: controller,
                      allowedTypes: [AttachmentPickerType.images],
                    ),
                  );
                },
              ),
            ),
          );

          await tester.pumpAndSettle();

          final picker = tester.widget<StreamTabbedAttachmentPicker>(
            find.byType(StreamTabbedAttachmentPicker),
          );

          expect(
            picker.options.every(
              (option) => option.supportedTypes.contains(AttachmentPickerType.images),
            ),
            isTrue,
          );
        },
      );
    });
  });

  group('systemAttachmentPickerBuilder', () {
    group('optionsBuilder', () {
      testWidgets(
        'should call optionsBuilder with default options',
        (tester) async {
          var builderCalled = false;

          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return systemAttachmentPickerBuilder(
                    context: context,
                    controller: controller,
                    optionsBuilder: (context, defaultOptions) {
                      builderCalled = true;
                      return defaultOptions;
                    },
                  );
                },
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(builderCalled, isTrue);
          expect(
            find.byType(StreamSystemAttachmentPicker),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'should allow adding custom system picker options',
        (tester) async {
          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return systemAttachmentPickerBuilder(
                    context: context,
                    controller: controller,
                    optionsBuilder: (context, defaultOptions) {
                      return [
                        ...defaultOptions,
                        SystemAttachmentPickerOption(
                          key: 'custom-upload',
                          icon: Icons.cloud_upload,
                          title: 'Custom Upload',
                          supportedTypes: [AttachmentPickerType.files],
                          onTap: (context, controller) async {},
                        ),
                      ];
                    },
                  );
                },
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('Custom Upload'), findsOneWidget);
        },
      );

      testWidgets(
        'should throw ArgumentError when wrong option types are provided',
        (tester) async {
          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return systemAttachmentPickerBuilder(
                    context: context,
                    controller: controller,
                    optionsBuilder: (context, defaultOptions) {
                      return [
                        TabbedAttachmentPickerOption(
                          key: 'wrong',
                          icon: Icons.error,
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
              ),
            ),
          );

          expect(tester.takeException(), isA<ArgumentError>());
        },
      );
    });

    group('allowedTypes', () {
      testWidgets(
        'should filter options based on allowedTypes',
        (tester) async {
          final controller = StreamAttachmentPickerController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _wrapWithStreamChatApp(
              Builder(
                builder: (context) {
                  return systemAttachmentPickerBuilder(
                    context: context,
                    controller: controller,
                    allowedTypes: [AttachmentPickerType.images],
                  );
                },
              ),
            ),
          );

          await tester.pumpAndSettle();

          final picker = tester.widget<StreamSystemAttachmentPicker>(
            find.byType(StreamSystemAttachmentPicker),
          );

          expect(
            picker.options.every(
              (option) => option.supportedTypes.contains(AttachmentPickerType.images),
            ),
            isTrue,
          );
        },
      );
    });
  });
}

Widget _wrapWithStreamChatApp(
  Widget widget,
) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.streamColorScheme.backgroundApp,
            body: widget,
          );
        },
      ),
    ),
  );
}
