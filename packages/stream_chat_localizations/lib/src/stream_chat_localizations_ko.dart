part of 'stream_chat_localizations.dart';

/// The translations for Korean (`ko`).
class StreamChatLocalizationsKo extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Korean.
  const StreamChatLocalizationsKo({String localeName = 'ko'})
      : super(localeName: localeName);

  @override
  String get launchUrlError => 'URL을 시작할 수 없습니다.';

  @override
  String get loadingUsersError => '사용자를 로드하는 중 오류 발생';

  @override
  String get noUsersLabel => '현재 사용자가 없습니다.';

  @override
  String get retryLabel => '다시 시도하십시오.';

  @override
  String get userLastOnlineText => '마지막 온라인입니다.';

  @override
  String get userOnlineText => '온라인.';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} 타이핑하고 있어요.';
    }
    return '${first.name}스와 ${users.length - 1}명이 타자를 치고 있습니다';
  }

  @override
  String get threadReplyLabel => '스레드 응답입니다.';

  @override
  String get onlyVisibleToYouText => '당신만 볼 수 있습니다.';

  @override
  String threadReplyCountText(int count) => '$count스레드 응답입니다.';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      '${total}mb 중 ${remaining}mb를 업로드하는 중입니다...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return '당신에 의해 고정됩니다.';
    return '${pinnedBy.name} 핀으로 고정했습니다.';
  }

  @override
  String get emptyMessagesText => '현재 메시지가 없습니다.';

  @override
  String get genericErrorText => '뭔가 잘못됐어요';

  @override
  String get loadingMessagesError => '메시지를 로드하는 동안 오류가 발생했습니다.';

  @override
  String resultCountText(int count) => '$count개 결과입니다.';

  @override
  String get messageDeletedText => '이 메시지는 삭제되었습니다.';

  @override
  String get messageDeletedLabel => '메시지가 삭제되었습니다.';

  @override
  String get messageReactionsLabel => '메시지에 대한 응답.';

  @override
  String get emptyChatMessagesText => '아직 채팅이 없습니다...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 회신합니다.';
    return '$replyCount개의 응답입니다.';
  }

  @override
  String get connectedLabel => '연결된';

  @override
  String get disconnectedLabel => '연결이 끊겼습니다.';

  @override
  String get reconnectingLabel => '다시 연결하는 중...';

  @override
  String get alsoSendAsDirectMessageLabel => '다이렉트 메시지로도 보냅니다.';

  @override
  String get addACommentOrSendLabel => '주석을 추가하거나 보냅니다.';

  @override
  String get searchGifLabel => 'GIF를 검색합니다.';

  @override
  String get writeAMessageLabel => '메시지를 쓰세요.';

  @override
  String get instantCommandsLabel => '인스턴트 커맨즈';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      '파일이 너무 커서 업로드할 수 없습니다. '
      '파일 크기 제한은 ${limitInMB}MB입니다. '
      '우리는 압축해 보았지만 충분하지 않았습니다.';

  @override
  String fileTooLargeError(double limitInMB) =>
      '파일이 너무 커서 업로드할 수 없습니다. 파일 크기 제한은 ${limitInMB}MB입니다.';

  @override
  String emojiMatchingQueryText(String query) => '"$query"과 일치하는 이모티콘입니다.';

  @override
  String get addAFileLabel => '파일을 추가합니다.';

  @override
  String get photoFromCameraLabel => '카메라에서 찍은 사진입니다.';

  @override
  String get uploadAFileLabel => '파일을 업로드합니다.';

  @override
  String get uploadAPhotoLabel => '사진을 업로드합니다.';

  @override
  String get uploadAVideoLabel => '비디오를 업로드하세요';

  @override
  String get videoFromCameraLabel => '카메라의 비디오입니다.';

  @override
  String get okLabel => '알았지';

  @override
  String get somethingWentWrongError => '뭔가 잘못됐어요';

  @override
  String get addMoreFilesLabel => '파일을 추가합니다.';

  @override
  String get enablePhotoAndVideoAccessMessage => '친구와 공유할 수 있도록 사진과'
      '\n동영상에 액세스할 수 있도록 설정하십시오.';

  @override
  String get allowGalleryAccessMessage => '갤러리에 대한 액세스를 허용합니다.';

  @override
  String get flagMessageLabel => '플래그 메시지';

  @override
  String get flagMessageQuestion => '추가 조사를 위해 진행자에게 이 메시지의 복사본을 전송하시겠습니까?';

  @override
  String get flagLabel => '플래그를 지정합니다.';

  @override
  String get cancelLabel => '취소하십시오.';

  @override
  String get flagMessageSuccessfulLabel => '메시지에 플래그가 지정되었습니다.';

  @override
  String get flagMessageSuccessfulText =>
      '메시지가 진행자에게 보고되었습니다.';

  @override
  String get deleteLabel => '삭제합니다.';

  @override
  String get deleteMessageLabel => '메시지를 삭제합니다.';

  @override
  String get deleteMessageQuestion =>
      '이 메시지를 완전히 삭제하시겠습니까?';

  @override
  String get operationCouldNotBeCompletedText =>
      '작업을 완료할 수 없습니다.';

  @override
  String get replyLabel => '답글';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return '대화에서 연결을 해제합니다.';
    return '대화에 고정합니다.';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return '메시지 삭제를 다시 시도하십시오.';
    return '메시지를 삭제합니다.';
  }

  @override
  String get copyMessageLabel => '메시지를 복사합니다.';

  @override
  String get editMessageLabel => '메시지를 편집합니다.';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return '편집된 메시지를 다시 보냅니다.';
    return '다시 보냅니다.';
  }

  @override
  String get photosLabel => '사진들';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return '오늘이요';
    } else if (date == yesterday) {
      return '어제요';
    } else {
      return '${Jiffy(date).MMMd}입니다.';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '${_getDay(date)} 오전 ${Jiffy(time.toLocal()).format('HH:mm')}에 보냈습니다';

  @override
  String get todayLabel => '오늘이요';

  @override
  String get yesterdayLabel => '어제요';

  @override
  String get channelIsMutedText => '채널이 음소거됩니다.';

  @override
  String get noTitleText => '제목이 없습니다.';

  @override
  String get letsStartChattingLabel => '채팅 시작해요!';

  @override
  String get sendingFirstMessageLabel =>
      '친구에게 당신의 첫 번째 메시지를 보내는 것은 어떤가요?';

  @override
  String get startAChatLabel => '대화를 시작합니다.';

  @override
  String get loadingChannelsError => '채널을 로드하는 동안 오류가 발생했습니다.';

  @override
  String get deleteConversationLabel => '대화를 삭제합니다.';

  @override
  String get deleteConversationQuestion =>
      '이 대화를 삭제하시겠습니까?';

  @override
  String get streamChatLabel => '채팅을 스트리밍합니다.';

  @override
  String get searchingForNetworkText => '네트워크를 검색하는 중입니다.';

  @override
  String get offlineLabel => '오프라인...';

  @override
  String get tryAgainLabel => '다시 한 번 해 봐!';

  @override
  String membersCountText(int count) {
    if (count == 1) return '회원 1명입니다.';
    return '$count 구성원';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 온라인입니다.';
    return '$count 온라인입니다';
  }

  @override
  String get viewInfoLabel => '정보를 봅니다.';

  @override
  String get leaveGroupLabel => '그룹을 떠납니다.';

  @override
  String get leaveLabel => '떠나요';

  @override
  String get leaveConversationLabel => '대화에서 떠납니다.';

  @override
  String get leaveConversationQuestion =>
      '정말 이 대화에서 나가시겠습니까?';

  @override
  String get showInChatLabel => '채팅에 표시합니다.';

  @override
  String get saveImageLabel => '이미지를 저장합니다.';

  @override
  String get saveVideoLabel => '비디오를 저장합니다.';

  @override
  String get uploadErrorLabel => '업로드 오류입니다.';

  @override
  String get giphyLabel => '지피요';

  @override
  String get shuffleLabel => '섞으세요';

  @override
  String get sendLabel => '보냅니다';

  @override
  String get withText => '함께요';

  @override
  String get inText => '에 있습니다.';

  @override
  String get youText => '너';

  @override
  String galleryPaginationText(
          {required int currentPage, required int totalPages}) =>
      '$totalPages장 ${currentPage + 1}장입니다';
      //11장 3장.

  @override
  String get fileText => '파일';

  @override
  String get replyToMessageLabel => '메시지에 회신합니다.';
}
