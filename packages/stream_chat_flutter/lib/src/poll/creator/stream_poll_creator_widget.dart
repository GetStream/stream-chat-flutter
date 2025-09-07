import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_switch_list_tile.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
  });

  /// The padding around the poll creator.
  final EdgeInsets padding;

  /// Whether the scroll view should shrink-wrap its content.
  final bool shrinkWrap;

  /// The physics of the scroll view.
  final ScrollPhysics? physics;

  /// The controller used to manage the state of the poll.
  final StreamPollController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, poll, child) {
        final config = controller.config;
        final translations = context.translations;

        // Using a combination of SingleChildScrollView and Column instead of
        // ListView to avoid the item color overflow issue.
        //
        // More info: https://github.com/flutter/flutter/issues/86584
        return SingleChildScrollView(
          padding: padding,
          physics: physics,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PollQuestionTextField(
                questionRange: config.nameRange,
                title: translations.questionsLabel,
                hintText: translations.askAQuestionLabel,
                initialQuestion: PollQuestion(id: poll.id, text: poll.name),
                onChanged: (question) => controller.question = question.text,
              ),
              const SizedBox(height: 32),
              PollOptionReorderableListView(
                title: translations.optionLabel(isPlural: true),
                itemHintText: translations.optionLabel(),
                allowDuplicate: config.allowDuplicateOptions,
                optionsRange: config.optionsRange,
                initialOptions: [
                  for (final option in poll.options)
                    PollOptionItem(id: option.id, text: option.text),
                ],
                onOptionsChanged: (options) => controller.options = [
                  for (final option in options)
                    PollOption(id: option.id, text: option.text),
                ],
              ),
              const SizedBox(height: 32),
              PollSwitchListTile(
                title: translations.multipleAnswersLabel,
                value: poll.enforceUniqueVote == false,
                onChanged: (value) {
                  controller.enforceUniqueVote = !value;
                  // We also need to reset maxVotesAllowed if disabled.
                  if (value case false) controller.maxVotesAllowed = null;
                },
                children: [
                  PollSwitchTextField(
                    hintText: translations.maximumVotesPerPersonLabel,
                    item: PollSwitchItem(
                      value: poll.maxVotesAllowed != null,
                      inputValue: poll.maxVotesAllowed,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (item) {
                      if (config.allowedVotesRange case final allowedRange?) {
                        final votes = item.inputValue;
                        if (votes == null) return null;

                        return translations.maxVotesPerPersonValidationError(
                          votes,
                          allowedRange,
                        );
                      }

                      return null;
                    },
                    onChanged: (option) {
                      final enabled = option.value;
                      final maxVotes = option.inputValue;

                      controller.maxVotesAllowed = enabled ? maxVotes : null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              PollSwitchListTile(
                title: translations.anonymousPollLabel,
                value: poll.votingVisibility == VotingVisibility.anonymous,
                onChanged: (anon) => controller.votingVisibility = anon //
                    ? VotingVisibility.anonymous
                    : VotingVisibility.public,
              ),
              const SizedBox(height: 8),
              PollSwitchListTile(
                title: translations.suggestAnOptionLabel,
                value: poll.allowUserSuggestedOptions,
                onChanged: (allow) => controller.allowSuggestions = allow,
              ),
              const SizedBox(height: 8),
              PollSwitchListTile(
                title: translations.addACommentLabel,
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
