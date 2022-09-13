import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('Default translations should exist', () {
    const translations = DefaultTranslations.instance;
    expect(translations.launchUrlError, isNotNull);
    expect(translations.loadingUsersError, isNotNull);
    expect(translations.noUsersLabel, isNotNull);
    expect(translations.retryLabel, isNotNull);
    expect(translations.userLastOnlineText, isNotNull);
    expect(translations.userOnlineText, isNotNull);
    expect(translations.userOnlineText, isNotNull);
    // no users
    expect(translations.userTypingText([]), isNotNull);
    // single user
    expect(translations.userTypingText([User(id: 'test-id')]), isNotNull);
    // multiple users
    expect(
      translations.userTypingText([
        User(id: 'test-id-1'),
        User(id: 'test-id-2'),
      ]),
      isNotNull,
    );
    expect(translations.threadReplyLabel, isNotNull);
    expect(translations.onlyVisibleToYouText, isNotNull);
    expect(translations.threadReplyCountText(3), isNotNull);
    expect(
      translations.attachmentsUploadProgressText(remaining: 3, total: 10),
      isNotNull,
    );
    expect(
      translations.pinnedByUserText(
        pinnedBy: User(id: 'pinned-by-user-id'),
        currentUser: OwnUser(id: 'current-user-id'),
      ),
      isNotNull,
    );
    expect(translations.emptyMessagesText, isNotNull);
    expect(translations.genericErrorText, isNotNull);
    expect(translations.loadingMessagesError, isNotNull);
    expect(translations.resultCountText(3), isNotNull);
    expect(translations.messageDeletedText, isNotNull);
    expect(translations.messageDeletedLabel, isNotNull);
    expect(translations.messageReactionsLabel, isNotNull);
    expect(translations.emptyChatMessagesText, isNotNull);
    expect(translations.threadSeparatorText(3), isNotNull);
    expect(translations.connectedLabel, isNotNull);
    expect(translations.disconnectedLabel, isNotNull);
    expect(translations.reconnectingLabel, isNotNull);
    expect(translations.alsoSendAsDirectMessageLabel, isNotNull);
    expect(translations.addACommentOrSendLabel, isNotNull);
    expect(translations.searchGifLabel, isNotNull);
    expect(translations.writeAMessageLabel, isNotNull);
    expect(translations.instantCommandsLabel, isNotNull);
    expect(translations.fileTooLargeAfterCompressionError(33), isNotNull);
    expect(translations.fileTooLargeError(33), isNotNull);
    expect(translations.addAFileLabel, isNotNull);
    expect(translations.photoFromCameraLabel, isNotNull);
    expect(translations.uploadAFileLabel, isNotNull);
    expect(translations.uploadAPhotoLabel, isNotNull);
    expect(translations.uploadAVideoLabel, isNotNull);
    expect(translations.videoFromCameraLabel, isNotNull);
    expect(translations.okLabel, isNotNull);
    expect(translations.somethingWentWrongError, isNotNull);
    expect(translations.addMoreFilesLabel, isNotNull);
    expect(translations.enablePhotoAndVideoAccessMessage, isNotNull);
    expect(translations.allowGalleryAccessMessage, isNotNull);
    expect(translations.flagMessageLabel, isNotNull);
    expect(translations.flagMessageQuestion, isNotNull);
    expect(translations.flagLabel, isNotNull);
    expect(translations.cancelLabel, isNotNull);
    expect(translations.flagMessageSuccessfulLabel, isNotNull);
    expect(translations.flagMessageSuccessfulText, isNotNull);
    expect(translations.deleteLabel, isNotNull);
    expect(translations.deleteMessageLabel, isNotNull);
    expect(translations.deleteMessageQuestion, isNotNull);
    expect(translations.operationCouldNotBeCompletedText, isNotNull);
    expect(translations.replyLabel, isNotNull);
    // pinned
    expect(translations.togglePinUnpinText(pinned: true), isNotNull);
    // un-pinned
    expect(translations.togglePinUnpinText(pinned: false), isNotNull);
    // delete-failed
    expect(
      translations.toggleDeleteRetryDeleteMessageText(isDeleteFailed: true),
      isNotNull,
    );
    // first-delete
    expect(
      translations.toggleDeleteRetryDeleteMessageText(isDeleteFailed: false),
      isNotNull,
    );
    expect(translations.copyMessageLabel, isNotNull);
    expect(translations.editMessageLabel, isNotNull);
    // resend-failed
    expect(
      translations.toggleResendOrResendEditedMessage(isUpdateFailed: true),
      isNotNull,
    );
    // first resend
    expect(
      translations.toggleResendOrResendEditedMessage(isUpdateFailed: false),
      isNotNull,
    );
    expect(translations.photosLabel, isNotNull);
    // today
    expect(
      translations.sentAtText(
        date: DateTime.now(),
        time: DateTime.now(),
      ),
      isNotNull,
    );
    // yesterday
    expect(
      translations.sentAtText(
        date: DateTime.now().subtract(const Duration(days: 1)),
        time: DateTime.now(),
      ),
      isNotNull,
    );
    // any other day
    expect(
      translations.sentAtText(
        date: DateTime.now().subtract(const Duration(days: 3)),
        time: DateTime.now(),
      ),
      isNotNull,
    );
    expect(translations.todayLabel, isNotNull);
    expect(translations.yesterdayLabel, isNotNull);
    expect(translations.channelIsMutedText, isNotNull);
    expect(translations.noTitleText, isNotNull);
    expect(translations.letsStartChattingLabel, isNotNull);
    expect(translations.sendingFirstMessageLabel, isNotNull);
    expect(translations.startAChatLabel, isNotNull);
    expect(translations.loadingChannelsError, isNotNull);
    expect(translations.deleteConversationLabel, isNotNull);
    expect(translations.deleteConversationQuestion, isNotNull);
    expect(translations.streamChatLabel, isNotNull);
    expect(translations.searchingForNetworkText, isNotNull);
    expect(translations.offlineLabel, isNotNull);
    expect(translations.tryAgainLabel, isNotNull);
    // 1 member
    expect(translations.membersCountText(1), isNotNull);
    // 3 members
    expect(translations.membersCountText(3), isNotNull);
    // 1 member
    expect(translations.watchersCountText(1), isNotNull);
    // 3 members
    expect(translations.watchersCountText(3), isNotNull);
    expect(translations.viewInfoLabel, isNotNull);
    expect(translations.leaveGroupLabel, isNotNull);
    expect(translations.leaveLabel, isNotNull);
    expect(translations.leaveConversationLabel, isNotNull);
    expect(translations.leaveConversationQuestion, isNotNull);
    expect(translations.showInChatLabel, isNotNull);
    expect(translations.saveImageLabel, isNotNull);
    expect(translations.saveVideoLabel, isNotNull);
    expect(translations.uploadErrorLabel, isNotNull);
    expect(translations.giphyLabel, isNotNull);
    expect(translations.shuffleLabel, isNotNull);
    expect(translations.sendLabel, isNotNull);
    expect(translations.withText, isNotNull);
    expect(translations.inText, isNotNull);
    expect(translations.youText, isNotNull);
    expect(translations.galleryPaginationText, isNotNull);
    expect(translations.fileText, isNotNull);
    expect(translations.replyToMessageLabel, isNotNull);
  });
}
