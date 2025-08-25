import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('AttachmentPickerOptionsBuilder', () {
    testWidgets(
        'mobileAttachmentPickerBuilder uses optionsBuilder when provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final controller = StreamAttachmentPickerController();

              const customOption = AttachmentPickerOption(
                key: 'custom-option',
                icon: Icon(Icons.star),
                supportedTypes: [AttachmentPickerType.files],
              );

              final widget = mobileAttachmentPickerBuilder(
                context: context,
                controller: controller,
                optionsBuilder: (context, defaultOptions) {
                  // Custom options after default options
                  return [
                    ...defaultOptions,
                    customOption,
                  ];
                },
              );

              expect(widget, isA<StreamMobileAttachmentPickerBottomSheet>());

              final bottomSheet =
                  widget as StreamMobileAttachmentPickerBottomSheet;
              final options = bottomSheet.options.toList();

              // Custom option should be last when added after default options
              expect(options.last.key, equals('custom-option'));

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets(
        'mobileAttachmentPickerBuilder can reorder options with optionsBuilder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final controller = StreamAttachmentPickerController();

              const customOption = AttachmentPickerOption(
                key: 'custom-option',
                icon: Icon(Icons.star),
                supportedTypes: [AttachmentPickerType.files],
              );

              final widget = mobileAttachmentPickerBuilder(
                context: context,
                controller: controller,
                optionsBuilder: (context, defaultOptions) {
                  // Custom option first, then only specific default options
                  return [
                    customOption,
                    // Only include gallery picker from defaults
                    ...defaultOptions
                        .where((option) => option.key == 'gallery-picker'),
                  ];
                },
              );

              expect(widget, isA<StreamMobileAttachmentPickerBottomSheet>());

              final bottomSheet =
                  widget as StreamMobileAttachmentPickerBottomSheet;
              final options = bottomSheet.options.toList();

              // Should have exactly 2 options: custom + gallery
              expect(options.length, equals(2));
              expect(options.first.key, equals('custom-option'));
              expect(options.last.key, equals('gallery-picker'));

              return Container();
            },
          ),
        ),
      );
    });

    test('AttachmentPickerOptionsBuilder typedef is defined correctly', () {
      // Test that the typedef is properly defined and can be used
      AttachmentPickerOptionsBuilder? builder;

      builder = (context, defaultOptions) {
        return [
          ...defaultOptions,
          const AttachmentPickerOption(
            key: 'test-option',
            icon: Icon(Icons.star),
            supportedTypes: [AttachmentPickerType.files],
          ),
        ];
      };

      expect(builder, isNotNull);
      expect(builder, isA<AttachmentPickerOptionsBuilder>());
    });

    test(
        'WebOrDesktopAttachmentPickerOptionsBuilder typedef is defined correctly',
        () {
      // Test that the typedef is properly defined and can be used
      WebOrDesktopAttachmentPickerOptionsBuilder? builder;

      builder = (context, defaultOptions) {
        return [
          ...defaultOptions,
          WebOrDesktopAttachmentPickerOption(
            key: 'test-option',
            type: AttachmentPickerType.files,
            icon: const Icon(Icons.star),
            title: 'Test Option',
          ),
        ];
      };

      expect(builder, isNotNull);
      expect(builder, isA<WebOrDesktopAttachmentPickerOptionsBuilder>());
    });

    testWidgets(
        'customOptions behavior still works when optionsBuilder is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final controller = StreamAttachmentPickerController();

              const customOption = AttachmentPickerOption(
                key: 'custom-option',
                icon: Icon(Icons.star),
                supportedTypes: [AttachmentPickerType.files],
              );

              final widget = mobileAttachmentPickerBuilder(
                context: context,
                controller: controller,
                customOptions: [customOption],
              );

              expect(widget, isA<StreamMobileAttachmentPickerBottomSheet>());

              final bottomSheet =
                  widget as StreamMobileAttachmentPickerBottomSheet;
              final options = bottomSheet.options.toList();

              expect(options.first.key, equals('custom-option'));

              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('Cannot use both customOptions and optionsBuilder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                () => showStreamAttachmentPickerModalBottomSheet(
                  context: context,
                  customOptions: [
                    const AttachmentPickerOption(
                      key: 'custom',
                      icon: Icon(Icons.star),
                      supportedTypes: [AttachmentPickerType.files],
                    ),
                  ],
                  optionsBuilder: (context, defaultOptions) => defaultOptions,
                ),
                throwsAssertionError,
              );

              return Container();
            },
          ),
        ),
      );
    });
  });
}
