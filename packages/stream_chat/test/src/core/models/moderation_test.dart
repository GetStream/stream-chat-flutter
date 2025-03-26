import 'package:stream_chat/src/core/models/moderation.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/moderation', () {
    group('Moderation', () {
      test('should create with required properties only', () {
        const moderation = Moderation(
          action: ModerationAction.flag,
          originalText: 'original message text',
        );

        expect(moderation.action, ModerationAction.flag);
        expect(moderation.originalText, 'original message text');
        expect(moderation.textHarms, isNull);
        expect(moderation.imageHarms, isNull);
        expect(moderation.blocklistMatched, isNull);
        expect(moderation.semanticFilterMatched, isNull);
        expect(moderation.platformCircumvented, isFalse);
      });

      test('should create with all properties', () {
        const moderation = Moderation(
          action: ModerationAction.shadow,
          originalText: 'original message text',
          textHarms: ['hate', 'profanity'],
          imageHarms: ['explicit'],
          blocklistMatched: 'profanity',
          semanticFilterMatched: 'harassment',
          platformCircumvented: true,
        );

        expect(moderation.action, ModerationAction.shadow);
        expect(moderation.originalText, 'original message text');
        expect(moderation.textHarms, ['hate', 'profanity']);
        expect(moderation.imageHarms, ['explicit']);
        expect(moderation.blocklistMatched, 'profanity');
        expect(moderation.semanticFilterMatched, 'harassment');
        expect(moderation.platformCircumvented, isTrue);
      });

      test('should create from JSON correctly', () {
        final json = {
          'action': 'shadow',
          'original_text': 'original message text',
          'text_harms': ['hate', 'profanity'],
          'image_harms': ['explicit'],
          'blocklist_matched': 'profanity',
          'semantic_filter_matched': 'harassment',
          'platform_circumvented': true,
        };

        final moderation = Moderation.fromJson(json);

        expect(moderation.action, ModerationAction.shadow);
        expect(moderation.originalText, 'original message text');
        expect(moderation.textHarms, ['hate', 'profanity']);
        expect(moderation.imageHarms, ['explicit']);
        expect(moderation.blocklistMatched, 'profanity');
        expect(moderation.semanticFilterMatched, 'harassment');
        expect(moderation.platformCircumvented, isTrue);
      });

      test('should serialize to JSON correctly', () {
        const moderation = Moderation(
          action: ModerationAction.bounce,
          originalText: 'original message text',
          textHarms: ['hate', 'profanity'],
          imageHarms: ['explicit'],
          blocklistMatched: 'profanity',
          semanticFilterMatched: 'harassment',
          platformCircumvented: true,
        );

        final json = moderation.toJson();

        expect(json['action'], 'bounce');
        expect(json['original_text'], 'original message text');
        expect(json['text_harms'], ['hate', 'profanity']);
        expect(json['image_harms'], ['explicit']);
        expect(json['blocklist_matched'], 'profanity');
        expect(json['semantic_filter_matched'], 'harassment');
        expect(json['platform_circumvented'], isTrue);
      });

      test('equals & hashCode should work correctly', () {
        const moderation1 = Moderation(
          action: ModerationAction.remove,
          originalText: 'original message text',
          textHarms: ['hate', 'profanity'],
        );

        const moderation2 = Moderation(
          action: ModerationAction.remove,
          originalText: 'original message text',
          textHarms: ['hate', 'profanity'],
        );

        const moderation3 = Moderation(
          action: ModerationAction.flag,
          originalText: 'original message text',
          textHarms: ['hate', 'profanity'],
        );

        expect(moderation1 == moderation2, isTrue);
        expect(moderation1 == moderation3, isFalse);
        expect(moderation1.hashCode == moderation2.hashCode, isTrue);
        expect(moderation1.hashCode == moderation3.hashCode, isFalse);
      });
    });

    group('ModerationAction', () {
      test('should create predefined constants correctly', () {
        expect(ModerationAction.bounce.action, 'bounce');
        expect(ModerationAction.flag.action, 'flag');
        expect(ModerationAction.remove.action, 'remove');
        expect(ModerationAction.shadow.action, 'shadow');
      });

      test('should work with string equality', () {
        expect(ModerationAction.bounce == 'bounce', isTrue);
        expect(ModerationAction.flag == 'flag', isTrue);
        expect(ModerationAction.remove == 'remove', isTrue);
        expect(ModerationAction.shadow == 'shadow', isTrue);
      });

      test('should create custom action correctly', () {
        const customAction = ModerationAction('custom');
        expect(customAction.action, 'custom');
        expect(customAction == 'custom', isTrue);
      });

      test('should work in switch statements', () {
        const action = ModerationAction.bounce;

        final result = switch (action) {
          ModerationAction.bounce => 'bounce result',
          ModerationAction.flag => 'flag result',
          ModerationAction.remove => 'remove result',
          ModerationAction.shadow => 'shadow result',
          _ => 'other result',
        };

        expect(result, 'bounce result');
      });

      group('fromJson', () {
        test('should create from standard string correctly', () {
          expect(ModerationAction.fromJson('bounce'), ModerationAction.bounce);
          expect(ModerationAction.fromJson('flag'), ModerationAction.flag);
          expect(ModerationAction.fromJson('remove'), ModerationAction.remove);
          expect(ModerationAction.fromJson('shadow'), ModerationAction.shadow);
        });

        test('should create from custom string correctly', () {
          expect(ModerationAction.fromJson('custom'),
              const ModerationAction('custom'));
        });

        test('should handle legacy v1 moderation actions correctly', () {
          expect(
            ModerationAction.fromJson('MESSAGE_RESPONSE_ACTION_FLAG'),
            ModerationAction.flag,
          );
          expect(
            ModerationAction.fromJson('MESSAGE_RESPONSE_ACTION_BOUNCE'),
            ModerationAction.bounce,
          );
          expect(
            ModerationAction.fromJson('MESSAGE_RESPONSE_ACTION_BLOCK'),
            ModerationAction.remove,
          );
        });
      });

      group('toJson', () {
        test('should serialize standard actions correctly', () {
          expect(ModerationAction.toJson(ModerationAction.bounce), 'bounce');
          expect(ModerationAction.toJson(ModerationAction.flag), 'flag');
          expect(ModerationAction.toJson(ModerationAction.remove), 'remove');
          expect(ModerationAction.toJson(ModerationAction.shadow), 'shadow');
          expect(ModerationAction.toJson(const ModerationAction('custom')),
              'custom');
        });

        test('should serialize legacy v1 action strings correctly', () {
          // Create ModerationAction instances from legacy v1 strings
          final legacyFlag = ModerationAction.fromJson(
            'MESSAGE_RESPONSE_ACTION_FLAG',
          );
          final legacyBounce = ModerationAction.fromJson(
            'MESSAGE_RESPONSE_ACTION_BOUNCE',
          );
          final legacyBlock = ModerationAction.fromJson(
            'MESSAGE_RESPONSE_ACTION_BLOCK',
          );

          // Verify they're serialized to v2 format
          expect(ModerationAction.toJson(legacyFlag), 'flag');
          expect(ModerationAction.toJson(legacyBounce), 'bounce');
          expect(ModerationAction.toJson(legacyBlock), 'remove');
        });
      });
    });
  });
}
