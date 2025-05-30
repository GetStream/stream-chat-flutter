import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/src/stream_chat_localizations.dart';

void main() {
  for (final language in kStreamChatSupportedLanguages) {
    test('translations exist for $language', () async {
      final locale = Locale(language);
      expect(
          GlobalStreamChatLocalizations.delegate.isSupported(locale), isTrue);
      final localizations =
          await GlobalStreamChatLocalizations.delegate.load(locale);
      expect(localizations.launchUrlError, isNotNull);
      expect(localizations.loadingUsersError, isNotNull);
      expect(localizations.noUsersLabel, isNotNull);
      expect(localizations.noPhotoOrVideoLabel, isNotNull);
      expect(localizations.retryLabel, isNotNull);
      expect(localizations.userLastOnlineText, isNotNull);
      expect(localizations.userOnlineText, isNotNull);
      expect(localizations.userOnlineText, isNotNull);
      expect(localizations.draftLabel, isNotNull);
      // no users
      expect(localizations.userTypingText([]), isNotNull);
      // single user
      expect(localizations.userTypingText([User(id: 'test-id')]), isNotNull);
      // multiple users
      expect(
        localizations.userTypingText([
          User(id: 'test-id-1'),
          User(id: 'test-id-2'),
        ]),
        isNotNull,
      );
      expect(localizations.threadReplyLabel, isNotNull);
      expect(localizations.onlyVisibleToYouText, isNotNull);
      expect(localizations.editedMessageLabel, isNotNull);
      expect(localizations.threadReplyCountText(3), isNotNull);
      expect(
        localizations.attachmentsUploadProgressText(remaining: 3, total: 10),
        isNotNull,
      );
      expect(
        localizations.pinnedByUserText(
          pinnedBy: User(id: 'pinned-by-user-id'),
          currentUser: OwnUser(id: 'current-user-id'),
        ),
        isNotNull,
      );
      expect(localizations.emptyMessagesText, isNotNull);
      expect(localizations.genericErrorText, isNotNull);
      expect(localizations.loadingMessagesError, isNotNull);
      expect(localizations.resultCountText(3), isNotNull);
      expect(localizations.messageDeletedText, isNotNull);
      expect(localizations.messageDeletedLabel, isNotNull);
      expect(localizations.systemMessageLabel, isNotNull);
      expect(localizations.messageReactionsLabel, isNotNull);
      expect(localizations.emptyChatMessagesText, isNotNull);
      expect(localizations.threadSeparatorText(3), isNotNull);
      expect(localizations.connectedLabel, isNotNull);
      expect(localizations.disconnectedLabel, isNotNull);
      expect(localizations.reconnectingLabel, isNotNull);
      expect(localizations.alsoSendAsDirectMessageLabel, isNotNull);
      expect(localizations.addACommentOrSendLabel, isNotNull);
      expect(localizations.searchGifLabel, isNotNull);
      expect(localizations.writeAMessageLabel, isNotNull);
      expect(localizations.instantCommandsLabel, isNotNull);
      expect(localizations.fileTooLargeAfterCompressionError(33), isNotNull);
      expect(localizations.fileTooLargeError(33), isNotNull);
      expect(localizations.addAFileLabel, isNotNull);
      expect(localizations.photoFromCameraLabel, isNotNull);
      expect(localizations.uploadAFileLabel, isNotNull);
      expect(localizations.uploadAPhotoLabel, isNotNull);
      expect(localizations.uploadAVideoLabel, isNotNull);
      expect(localizations.videoFromCameraLabel, isNotNull);
      expect(localizations.okLabel, isNotNull);
      expect(localizations.somethingWentWrongError, isNotNull);
      expect(localizations.addMoreFilesLabel, isNotNull);
      expect(localizations.enablePhotoAndVideoAccessMessage, isNotNull);
      expect(localizations.allowGalleryAccessMessage, isNotNull);
      expect(localizations.flagMessageLabel, isNotNull);
      expect(localizations.flagMessageQuestion, isNotNull);
      expect(localizations.flagLabel, isNotNull);
      expect(localizations.cancelLabel, isNotNull);
      expect(localizations.flagMessageSuccessfulLabel, isNotNull);
      expect(localizations.flagMessageSuccessfulText, isNotNull);
      expect(localizations.deleteLabel, isNotNull);
      expect(localizations.deleteMessageLabel, isNotNull);
      expect(localizations.deleteMessageQuestion, isNotNull);
      expect(localizations.operationCouldNotBeCompletedText, isNotNull);
      expect(localizations.replyLabel, isNotNull);
      // pinned
      expect(localizations.togglePinUnpinText(pinned: true), isNotNull);
      // un-pinned
      expect(localizations.togglePinUnpinText(pinned: false), isNotNull);
      // delete-failed
      expect(
        localizations.toggleDeleteRetryDeleteMessageText(isDeleteFailed: true),
        isNotNull,
      );
      // first-delete
      expect(
        localizations.toggleDeleteRetryDeleteMessageText(isDeleteFailed: false),
        isNotNull,
      );
      expect(localizations.copyMessageLabel, isNotNull);
      expect(localizations.editMessageLabel, isNotNull);
      // resend-failed
      expect(
        localizations.toggleResendOrResendEditedMessage(isUpdateFailed: true),
        isNotNull,
      );
      // first resend
      expect(
        localizations.toggleResendOrResendEditedMessage(isUpdateFailed: false),
        isNotNull,
      );
      expect(localizations.photosLabel, isNotNull);
      // today
      expect(
        localizations.sentAtText(
          date: DateTime.now(),
          time: DateTime.now(),
        ),
        isNotNull,
      );
      // yesterday
      expect(
        localizations.sentAtText(
          date: DateTime.now().subtract(const Duration(days: 1)),
          time: DateTime.now(),
        ),
        isNotNull,
      );
      // any other day
      expect(
        localizations.sentAtText(
          date: DateTime.now().subtract(const Duration(days: 3)),
          time: DateTime.now(),
        ),
        isNotNull,
      );
      expect(localizations.todayLabel, isNotNull);
      expect(localizations.yesterdayLabel, isNotNull);
      expect(localizations.channelIsMutedText, isNotNull);
      expect(localizations.noTitleText, isNotNull);
      expect(localizations.letsStartChattingLabel, isNotNull);
      expect(localizations.sendingFirstMessageLabel, isNotNull);
      expect(localizations.startAChatLabel, isNotNull);
      expect(localizations.loadingChannelsError, isNotNull);
      expect(localizations.deleteConversationLabel, isNotNull);
      expect(localizations.deleteConversationQuestion, isNotNull);
      expect(localizations.streamChatLabel, isNotNull);
      expect(localizations.searchingForNetworkText, isNotNull);
      expect(localizations.offlineLabel, isNotNull);
      expect(localizations.tryAgainLabel, isNotNull);
      // 1 member
      expect(localizations.membersCountText(1), isNotNull);
      // 3 members
      expect(localizations.membersCountText(3), isNotNull);
      // 1 member
      expect(localizations.watchersCountText(1), isNotNull);
      // 3 members
      expect(localizations.watchersCountText(3), isNotNull);
      expect(localizations.viewInfoLabel, isNotNull);
      expect(localizations.leaveGroupLabel, isNotNull);
      expect(localizations.leaveLabel, isNotNull);
      expect(localizations.leaveConversationLabel, isNotNull);
      expect(localizations.leaveConversationQuestion, isNotNull);
      expect(localizations.showInChatLabel, isNotNull);
      expect(localizations.saveImageLabel, isNotNull);
      expect(localizations.saveVideoLabel, isNotNull);
      expect(localizations.uploadErrorLabel, isNotNull);
      expect(localizations.giphyLabel, isNotNull);
      expect(localizations.shuffleLabel, isNotNull);
      expect(localizations.sendLabel, isNotNull);
      expect(localizations.withText, isNotNull);
      expect(localizations.inText, isNotNull);
      expect(localizations.youText, isNotNull);
      expect(localizations.galleryPaginationText, isNotNull);
      expect(localizations.fileText, isNotNull);
      expect(localizations.replyToMessageLabel, isNotNull);
      expect(localizations.attachmentLimitExceedError(3), isNotNull);
      expect(
        localizations.galleryPaginationText(currentPage: 1, totalPages: 2),
        isNotNull,
      );
      expect(localizations.slowModeOnLabel, isNotNull);
      expect(localizations.linkDisabledDetails, isNotNull);
      expect(localizations.linkDisabledError, isNotNull);
      expect(localizations.sendMessagePermissionError, isNotNull);
      expect(localizations.couldNotReadBytesFromFileError, isNotNull);
      expect(localizations.toggleMuteUnmuteAction(isMuted: false), isNotNull);
      expect(localizations.downloadLabel, isNotNull);
      expect(localizations.toggleMuteUnmuteGroupQuestion(isMuted: true),
          isNotNull);
      expect(localizations.toggleMuteUnmuteGroupText(isMuted: true), isNotNull);
      expect(
          localizations.toggleMuteUnmuteUserQuestion(isMuted: true), isNotNull);
      expect(localizations.toggleMuteUnmuteUserText(isMuted: true), isNotNull);
      expect(localizations.viewLibrary, isNotNull);
      expect(localizations.unreadMessagesSeparatorText(), isNotNull);
      expect(localizations.enableFileAccessMessage, isNotNull);
      expect(localizations.allowFileAccessMessage, isNotNull);
      expect(
          localizations.unreadCountIndicatorLabel(unreadCount: 2), isNotNull);
      expect(localizations.unreadMessagesSeparatorText(), isNotNull);
      expect(localizations.markUnreadError, isNotNull);
      expect(localizations.markAsUnreadLabel, isNotNull);
      // Create poll
      expect(localizations.createPollLabel(), isNotNull);
      // Create a new poll
      expect(localizations.createPollLabel(isNew: true), isNotNull);
      expect(localizations.questionsLabel, isNotNull);
      expect(localizations.askAQuestionLabel, isNotNull);
      // Question must be at least 5 characters long
      expect(
        localizations.pollQuestionValidationError(3, const (min: 5, max: 10)),
        isNotNull,
      );
      // Question must be at most 10 characters long
      expect(
        localizations.pollQuestionValidationError(11, const (min: 5, max: 10)),
        isNotNull,
      );
      // Option
      expect(localizations.optionLabel(), isNotNull);
      // Options
      expect(localizations.optionLabel(isPlural: true), isNotNull);
      expect(localizations.pollOptionEmptyError, isNotNull);
      expect(localizations.pollOptionDuplicateError, isNotNull);
      expect(localizations.addAnOptionLabel, isNotNull);
      expect(localizations.multipleAnswersLabel, isNotNull);
      expect(localizations.maximumVotesPerPersonLabel, isNotNull);
      // Vote count must be at least 1
      expect(
        localizations.maxVotesPerPersonValidationError(
          0,
          const (min: 1, max: 10),
        ),
        isNotNull,
      );
      // Vote count must be at most 10
      expect(
        localizations.maxVotesPerPersonValidationError(
          11,
          const (min: 1, max: 10),
        ),
        isNotNull,
      );
      expect(localizations.anonymousPollLabel, isNotNull);
      expect(localizations.suggestAnOptionLabel, isNotNull);
      expect(localizations.addACommentLabel, isNotNull);
      expect(localizations.endVoteConfirmationText, isNotNull);
      expect(localizations.createLabel, isNotNull);
      expect(localizations.endLabel, isNotNull);
      expect(localizations.endVoteLabel, isNotNull);
      expect(localizations.enterANewOptionLabel, isNotNull);
      expect(localizations.enterYourCommentLabel, isNotNull);
      expect(localizations.loadingPollVotesError, isNotNull);
      expect(localizations.noPollVotesLabel, isNotNull);
      expect(localizations.pollCommentsLabel, isNotNull);
      expect(localizations.pollOptionsLabel, isNotNull);
      expect(localizations.pollResultsLabel, isNotNull);
      // Voting mode
      expect(
        localizations.pollVotingModeLabel(const PollVotingMode.disabled()),
        isNotNull,
      );
      expect(
        localizations.pollVotingModeLabel(const PollVotingMode.unique()),
        isNotNull,
      );
      expect(
        localizations.pollVotingModeLabel(
          const PollVotingMode.limited(count: 3),
        ),
        isNotNull,
      );
      expect(
        localizations.pollVotingModeLabel(const PollVotingMode.all()),
        isNotNull,
      );
      expect(localizations.seeAllOptionsLabel(), isNotNull);
      expect(localizations.seeAllOptionsLabel(count: 3), isNotNull);
      expect(localizations.showAllVotesLabel(), isNotNull);
      expect(localizations.showAllVotesLabel(count: 3), isNotNull);
      expect(localizations.updateYourCommentLabel, isNotNull);
      expect(localizations.viewCommentsLabel, isNotNull);
      expect(localizations.viewResultsLabel, isNotNull);
      // Vote count
      expect(localizations.voteCountLabel(), isNotNull);
      expect(localizations.voteCountLabel(count: 3), isNotNull);
      expect(localizations.repliedToLabel, isNotNull);
      expect(localizations.newThreadsLabel(count: 3), isNotNull);
      expect(localizations.slideToCancelLabel, isNotNull);
      expect(localizations.holdToRecordLabel, isNotNull);
      expect(localizations.sendAnywayLabel, isNotNull);
      expect(localizations.moderatedMessageBlockedText, isNotNull);
      expect(localizations.moderationReviewModalTitle, isNotNull);
      expect(localizations.moderationReviewModalDescription, isNotNull);
      expect(localizations.emptyMessagePreviewText, isNotNull);
      expect(localizations.voiceRecordingText, isNotNull);
      expect(localizations.audioAttachmentText, isNotNull);
      expect(localizations.imageAttachmentText, isNotNull);
      expect(localizations.videoAttachmentText, isNotNull);
      expect(localizations.pollYouVotedText, isNotNull);
      expect(localizations.pollSomeoneVotedText('TestUser'), isNotNull);
      expect(localizations.pollYouCreatedText, isNotNull);
      expect(localizations.pollSomeoneCreatedText('TestUser'), isNotNull);
      expect(localizations.systemMessageLabel, isNotNull);
    });
  }

  test('should throw if try to load locale which is not supported', () async {
    const locale = Locale('not-supported-locale');
    try {
      getStreamChatTranslation(locale);
    } catch (e) {
      expect(e, isA<AssertionError>());
    }
  });

  test('`.toString`', () {
    final supportedLocales = kStreamChatSupportedLanguages.length;
    expect(
      GlobalStreamChatLocalizations.delegate.toString(),
      'GlobalStreamChatLocalizations.delegate($supportedLocales locales)',
    );
  });
}
