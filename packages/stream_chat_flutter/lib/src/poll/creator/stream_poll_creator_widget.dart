import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_config_option.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/theme/poll_creator_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template streamPollCreator}
/// A widget that allows users to create a poll.
///
/// The widget provides a form to create a poll with a question and multiple
/// options.
///
/// {@endtemplate}
class StreamPollCreatorWidget extends StatelessWidget {
  /// {@macro streamPollCreator}
  const StreamPollCreatorWidget({
    super.key,
    required this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.padding = const EdgeInsets.all(16),
    this.scrollController,
  });

  /// The padding around the poll creator.
  final EdgeInsets padding;

  /// Whether the scroll view should shrink-wrap its content.
  final bool shrinkWrap;

  /// The physics of the scroll view.
  final ScrollPhysics? physics;

  /// The controller used to manage the state of the poll.
  final StreamPollController controller;

  /// Optional scroll controller for the underlying scroll view.
  ///
  /// When the creator is hosted inside a [DraggableScrollableSheet] (e.g. by
  /// [showStreamPollCreatorSheet]), pass the controller provided by the sheet
  /// so drag gestures expand and collapse the sheet correctly.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, poll, child) {
        final spacing = context.streamSpacing;

        final config = controller.config;
        final translations = context.translations;

        // Using a combination of SingleChildScrollView and Column instead of
        // ListView to avoid the item color overflow issue.
        //
        // More info: https://github.com/flutter/flutter/issues/86584
        return SingleChildScrollView(
          padding: padding,
          physics: physics,
          controller: scrollController,
          keyboardDismissBehavior: .onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PollQuestionTextField(
                questionRange: config.nameRange,
                title: translations.questionLabel(),
                hintText: translations.askAQuestionLabel,
                initialQuestion: PollQuestion(id: poll.id, text: poll.name),
                onChanged: (question) => controller.question = question.text,
              ),
              SizedBox(height: spacing.xl),
              PollOptionReorderableListView(
                title: translations.optionLabel(isPlural: true),
                itemHintText: context.translations.addAnOptionLabel,
                allowDuplicate: config.allowDuplicateOptions,
                optionsRange: config.optionsRange,
                initialOptions: [
                  for (final option in poll.options) PollOptionItem(id: option.id, text: option.text),
                ],
                onOptionsChanged: (options) => controller.options = [
                  for (final option in options) PollOption(id: option.id, text: option.text),
                ],
              ),
              SizedBox(height: spacing.xxl),
              PollConfigOption(
                title: translations.multipleAnswersLabel,
                description: translations.multipleAnswersDescription,
                value: poll.enforceUniqueVote == false,
                onChanged: (value) {
                  controller.enforceUniqueVote = !value;
                  // We also need to reset maxVotesAllowed if disabled.
                  if (value case false) controller.maxVotesAllowed = null;
                },
                child: PollConfigOption(
                  contentPadding: EdgeInsets.zero,
                  title: translations.maximumVotesPerPersonLabel,
                  description: translations.maximumVotesPerPersonDescription(
                    config.allowedVotesRange,
                  ),
                  value: poll.maxVotesAllowed != null,
                  onChanged: (enabled) {
                    controller.maxVotesAllowed = enabled ? config.allowedVotesRange?.min ?? 2 : null;
                  },
                  child: StreamStepper(
                    min: config.allowedVotesRange?.min ?? 2,
                    max: config.allowedVotesRange?.max ?? 10,
                    value: poll.maxVotesAllowed ?? config.allowedVotesRange?.min ?? 2,
                    onChanged: (value) => controller.maxVotesAllowed = value,
                    style: theme.configOptionStyle?.stepperStyle,
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              PollConfigOption(
                title: translations.anonymousPollLabel,
                description: translations.anonymousPollDescription,
                value: poll.votingVisibility == .anonymous,
                onChanged: (anon) => controller.votingVisibility = anon ? .anonymous : .public,
              ),
              SizedBox(height: spacing.md),
              PollConfigOption(
                title: translations.suggestAnOptionLabel,
                description: translations.suggestAnOptionDescription,
                value: poll.allowUserSuggestedOptions,
                onChanged: (allow) => controller.allowSuggestions = allow,
              ),
              SizedBox(height: spacing.md),
              PollConfigOption(
                title: translations.addACommentLabel,
                description: translations.addACommentDescription,
                value: poll.allowAnswers,
                onChanged: (allow) => controller.allowComments = allow,
              ),
            ],
          ),
        );
      },
    );
  }
}
