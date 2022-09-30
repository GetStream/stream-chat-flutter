import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';

void main() {
  group('StreamChatConfigurationProvider', () {
    testWidgets(
      'should provide the StreamChatConfiguration class with default data',
      (t) async {
        final configuration = StreamChatConfigurationData();
        late final StreamChatConfigurationData configurationFromProvider;
        await t.pumpWidget(StreamChatConfiguration(
          data: configuration,
          child: Builder(
            builder: (context) {
              configurationFromProvider = StreamChatConfiguration.of(context);
              return const SizedBox();
            },
          ),
        ));

        expect(configuration, configurationFromProvider);
      },
    );

    testWidgets(
      'should provide the StreamChatConfiguration class with custom data',
      (t) async {
        final configuration = StreamChatConfigurationData().copyWith(
          enforceUniqueReactions: false,
        );
        late final StreamChatConfigurationData configurationFromProvider;
        await t.pumpWidget(StreamChatConfiguration(
          data: configuration,
          child: Builder(
            builder: (context) {
              configurationFromProvider = StreamChatConfiguration.of(context);
              return const SizedBox();
            },
          ),
        ));

        expect(configuration, configurationFromProvider);
      },
    );
  });
}
