part of 'stream_chat_localizations.dart';

/// The translations for Korean (`ko`).
class StreamChatLocalizationsKo extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Korean.
  const StreamChatLocalizationsKo({super.localeName = 'ko'});

  @override
  AccessibilityTranslations get accessibility => const _AccessibilityTranslationsKo();

  @override
  String get launchUrlError => 'URL을 시작할 수 없습니다';

  @override
  String get loadingUsersError => '사용자를 로드하는 중 오류 발생';

  @override
  String get noUsersLabel => '현재 사용자가 없습니다';

  @override
  String get noPhotoOrVideoLabel => '사진이나 동영상이 없습니다';

  @override
  String get retryLabel => '다시 시도하십시오';

  @override
  String get userLastOnlineText => '마지막 온라인입니다';

  @override
  String get userOnlineText => '온라인';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} 타이핑중';
    }
    return '${first.name}하고 ${users.length - 1}명 타이핑중';
  }

  @override
  String get threadReplyLabel => '스레드 답변';

  @override
  String get threadLabel => '스레드';

  @override
  String get onlyVisibleToYouText => '당신만 볼 수 있습니다';

  @override
  String threadReplyCountText(int count) => '$count스레드 답장';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => '$total개 중 $completed개 업로드됨...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return '당신의 핀';
    return '${pinnedBy.name}의 핀';
  }

  @override
  String get sendMessagePermissionError => '메시지를 보낼 수 있는 권한이 없습니다';

  @override
  String get emptyMessagesText => '아직 메시지가 없습니다';

  @override
  String get genericErrorText => '뭔가 잘못됐습니다';

  @override
  String get loadingMessagesError => '메시지를 로드하는 동안 오류가 발생했습니다';

  @override
  String resultCountText(int count) => '$count개의 결과';

  @override
  String get messageDeletedText => '이 메시지는 삭제되었습니다.';

  @override
  String get messageDeletedLabel => '메시지가 삭제되었습니다';

  @override
  String get systemMessageLabel => '시스템 메시지';

  @override
  String get editedMessageLabel => '편집됨';

  @override
  String get messageReactionsLabel => '메시지에 대한 응답';

  @override
  String get emptyChatMessagesText => '아직 채팅이 없습니다...';

  @override
  String threadSeparatorText(int replyCount) => '$replyCount개의 답장';

  @override
  String get connectedLabel => '연결중';

  @override
  String get disconnectedLabel => '연결이 끊겼습니다';

  @override
  String get reconnectingLabel => '다시 연결하는 중...';

  @override
  String get alsoSendAsDirectMessageLabel => '다이렉트 메시지로도 보냅니다';

  @override
  String get addACommentOrSendLabel => '주석을 추가하거나 보냅니다';

  @override
  String get searchGifLabel => 'GIF 검색';

  @override
  String get writeAMessageLabel => '메시지 보내기';

  @override
  String get instantCommandsLabel => '인스턴트 커맨즈';

  @override
  String get commandUnavailableWhileEditingError => 'Not available while editing';

  @override
  String get commandUnavailableWhileQuotingError => 'Not available while replying';

  @override
  String get commandUnavailableError => 'Command not available';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      '파일이 너무 커서 업로드할 수 없습니다. '
      '파일 크기 제한은 ${limitInMB}MB입니다. '
      '우리는 압축해 보았지만 충분하지 않았습니다.';

  @override
  String fileTooLargeError(double limitInMB) => '파일이 너무 커서 업로드할 수 없습니다. 파일 크기 제한은 ${limitInMB}MB입니다.';

  @override
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) return "'.$extension' 파일은 업로드를 지원하지 않습니다.";
    return '이 파일 형식은 업로드를 지원하지 않습니다.';
  }

  @override
  String get couldNotReadBytesFromFileError => '파일에서 바이트를 읽을 수 없습니다.';

  @override
  String get addAFileLabel => '파일을 추가함';

  @override
  String get photoFromCameraLabel => '카메라에서 찍은 사진';

  @override
  String get uploadAFileLabel => '파일을 업로드함';

  @override
  String get uploadAPhotoLabel => '사진을 업로드함';

  @override
  String get uploadAVideoLabel => '비디오를 업로드함';

  @override
  String get videoFromCameraLabel => '카메라의 비디오.';

  @override
  String get okLabel => '확인';

  @override
  String get somethingWentWrongError => '뭔가 잘못됐습느다';

  @override
  String get addMoreFilesLabel => '더 추가';

  @override
  String get enablePhotoAndVideoAccessMessage => '친구와 공유할 수 있도록 사진과 동영상에 액세스할 수 있도록 설정하십시오.';

  @override
  String get allowGalleryAccessMessage => '갤러리에 대한 액세스를 허용합니다';

  @override
  String get flagMessageLabel => ' 메시지를 플래그함';

  @override
  String get flagMessageQuestion => '추가 조사를 위해 진행자에게 이 메시지의 복사본을 전송하시겠습니까?';

  @override
  String get flagLabel => '플래그함';

  @override
  String get cancelLabel => '취소';

  @override
  String get flagMessageSuccessfulLabel => '메시지에 플래그가 지정되었습니다';

  @override
  String get flagMessageSuccessfulText => '메시지가 진행자에게 보고되었습니다.';

  @override
  String get deleteLabel => '삭제';

  @override
  String get deleteMessageLabel => '메시지를 삭제합니다.';

  @override
  String get deleteMessageQuestion => '이 메시지를 완전히 삭제하시겠습니까?';

  @override
  String get operationCouldNotBeCompletedText => '작업을 완료할 수 없습니다.';

  @override
  String get replyLabel => '답글';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return '대화의 핀을 분리합니다';
    return '대화에 고정합니다';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return '메시지 삭제를 다시 시도합니다';
    return '메시지를 삭제합니다';
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
  String get photosLabel => '사진';

  @override
  String get photosAndVideosLabel => '사진 및 동영상';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return '오늘';
    } else if (date == yesterday) {
      return '어제';
    } else {
      return '${Jiffy.parseFromDateTime(date).MMMd}에';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return '${_getDay(date)} ${atTime.jm}에 보냈습니다';
  }

  @override
  String get todayLabel => '오늘';

  @override
  String get yesterdayLabel => '어제';

  @override
  String get channelIsMutedText => '채널이 음소거됩니다.';

  @override
  String get noTitleText => '제목이 없습니다.';

  @override
  String get letsStartChattingLabel => '채팅 시작해요!';

  @override
  String get sendingFirstMessageLabel => '친구에게 첫 메시지를 보내 볼까요?';

  @override
  String get startAChatLabel => '대화를 시작합니다.';

  @override
  String get loadingChannelsError => '채널을 로드하는 동안 오류가 발생했습니다.';

  @override
  String get deleteConversationLabel => '대화를 삭제합니다.';

  @override
  String get deleteConversationQuestion => '대화를 삭제하시겠습니까?';

  @override
  String get streamChatLabel => '채팅';

  @override
  String get searchingForNetworkText => '네트워크를 검색하는 중입니다.';

  @override
  String get offlineLabel => '오프라인...';

  @override
  String get tryAgainLabel => '다시 시도합니다';

  @override
  String membersCountText(int count) => '$count명';

  @override
  String watchersCountText(int count) => '$count명이 온라인';

  @override
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members, ${watchersCountText(onlineCount)}';
  }

  @override
  String get viewInfoLabel => '정보를 보기';

  @override
  String get leaveGroupLabel => '그룹을 떠납니다.';

  @override
  String get leaveLabel => '떠나다';

  @override
  String get leaveConversationLabel => '대화에서 떠납니다.';

  @override
  String get leaveConversationQuestion => '정말 이 대화에서 나가시겠습니까?';

  @override
  String get showInChatLabel => '채팅에 표시합니다.';

  @override
  String get saveImageLabel => '이미지를 저장합니다.';

  @override
  String get saveVideoLabel => '비디오를 저장합니다.';

  @override
  String get uploadErrorLabel => '업로드 오류';

  @override
  String get giphyLabel => '지피';

  @override
  String get shuffleLabel => '섞기';

  @override
  String get sendLabel => '보내기';

  @override
  String get withText => '함께';

  @override
  String get inText => '에';

  // This is the word for 'customer' or 'user' because saying 'you' directly
  // is too informal and rude
  @override
  String get youText => '당신';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) => '${currentPage + 1} / $totalPages';

  //3 / 11

  @override
  String get fileText => '파일';

  @override
  String get replyToMessageLabel => '메시지에 회신합니다.';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => '슬로모드, $cooldownTimeOut초만 기다려 주세요\u2026';

  @override
  String get commandUsernameLabel => '@username';

  @override
  @override
  String get viewLibrary => '라이브러리 보기';

  @override
  String attachmentLimitExceedError(int limit) => '첨부 파일 제한 초과: $limit 이상의 첨부 파일을 추가할 수 없습니다';

  @override
  String get downloadLabel => '다운로드';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return '사용자 음소거 해제';
    } else {
      return '사용자 음소거';
    }
  }

  @override
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return '사용자 차단 해제';
    return '사용자 차단';
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return '이 그룹의 음소거를 해제하시겠습니까?';
    } else {
      return '이 그룹을 음소거하시겠습니까?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return '이 사용자의 음소거를 해제하시겠습니까?';
    } else {
      return '이 사용자를 음소거하시겠습니까?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return '음소거 해제';
    } else {
      return '무음';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return '그룹 음소거 해제';
    } else {
      return '음소거 그룹';
    }
  }

  @override
  String get linkDisabledDetails => '이 대화에서는 링크를 보낼 수 없습니다.';

  @override
  String get linkDisabledError => '링크가 비활성화되었습니다.';

  @override
  String unreadMessagesSeparatorText() => '새 메시지.';

  @override
  String get enableFileAccessMessage => '친구와 공유할 수 있도록 파일에 대한 액세스를 허용하세요.';

  @override
  String get allowFileAccessMessage => '파일에 대한 액세스 허용';

  @override
  String get markAsUnreadLabel => '읽지 않음으로 표시';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount 읽지 않음';
  }

  @override
  String get markUnreadError =>
      '메시지를 읽지 않음으로 표시하는 중 오류가 발생했습니다. 가장 최근 100개의 채널 메시지보다 오래된 읽지 않은 메시지는'
      ' 표시할 수 없습니다.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return '새 투표 만들기';
    return '투표 만들기';
  }

  @override
  String questionLabel({bool isPlural = false}) => '질문';

  @override
  String get askAQuestionLabel => '질문하기';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return '질문은 $min자 이상이어야 합니다.';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return '질문은 최대 $max자여야 합니다.';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return '옵션';
    return '선택';
  }

  @override
  String get pollOptionEmptyError => '옵션은 비워 둘 수 없습니다.';

  @override
  String get pollOptionDuplicateError => '이것은 이미 선택 사항입니다';

  @override
  String get addAnOptionLabel => '옵션 추가';

  @override
  String get multipleAnswersLabel => '복수 답변';

  @override
  String get maximumVotesPerPersonLabel => '1인당 최대 투표 수';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return '투표 수는 $min개 이상이어야 합니다.';
    }

    if (max != null && votes > max) {
      return '투표 수는 최대 $max개여야 합니다.';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => '익명 투표';

  @override
  String get pollOptionsLabel => '투표 옵션';

  @override
  String get suggestAnOptionLabel => '옵션 제안';

  @override
  String get enterANewOptionLabel => '새 옵션 입력';

  @override
  String get addACommentLabel => '댓글 추가';

  @override
  String get pollCommentsLabel => '투표 댓글';

  @override
  String get updateYourCommentLabel => '댓글 업데이트';

  @override
  String get enterYourCommentLabel => '댓글 입력';

  @override
  String get endVoteConfirmationTitle => '투표를 종료하시겠습니까?';

  @override
  String get endVoteConfirmationMessage => '지금 이 투표를 종료하시겠습니까? 종료하면 더 이상 아무도 이 투표에 참여할 수 없습니다.';

  @override
  String get deletePollOptionLabel => '옵션을 삭제합니다.';

  @override
  String get deletePollOptionQuestion => '이 옵션을 삭제하시겠습니까?';

  @override
  String get createLabel => '생성';

  @override
  String get endLabel => '종료';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => '투표 종료',
      unique: () => '하나 선택',
      limited: (count) => '최대 $count 선택',
      all: () => '하나 이상 선택',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return '모든 옵션 보기';
    return '모든 $count 옵션 보기';
  }

  @override
  String get viewCommentsLabel => '댓글 보기';

  @override
  String get viewResultsLabel => '결과 보기';

  @override
  String get endVoteLabel => '투표 종료';

  @override
  String get pollResultsLabel => '투표 결과';

  @override
  String get pollVotesLabel => '투표';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return '모든 투표 보기';
    return '모든 $count 투표 보기';
  }

  @override
  String get viewAllLabel => '모두 보기';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 표',
    1 => '1 표',
    _ => '$count 표',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '총 0 표',
    1 => '총 1 표',
    _ => '총 $count 표',
  };

  @override
  String get noPollVotesLabel => '현재 투표가 없습니다';

  @override
  String get loadingPollVotesError => '투표 로딩 오류';

  @override
  String get repliedToLabel => '회신:';

  @override
  String newThreadsLabel({required int count}) {
    return '$count개의 새 스레드';
  }

  @override
  String get loadingLabel => '로딩 중...';

  @override
  String get slideToCancelLabel => '슬라이드하여 취소';

  @override
  String get holdToRecordLabel => '길게 눌러서 녹음, 놓아서 전송';

  @override
  String get sendAnywayLabel => '그래도 보내기';

  @override
  String get moderatedMessageBlockedText => '메시지가 조정 정책에 의해 차단되었습니다';

  @override
  String get moderationReviewModalTitle => '확실합니까?';

  @override
  String get moderationReviewModalDescription => '''귀하의 댓글이 다른 사람들에게 어떤 영향을 미칠 수 있는지 고려하고 커뮤니티 가이드라인을 준수하세요.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => '음성 녹음';

  @override
  String get audioAttachmentText => '오디오';

  @override
  String get imageAttachmentText => '이미지';

  @override
  String get videoAttachmentText => '비디오';

  @override
  String get fileAttachmentText => '파일';

  @override
  String get linkAttachmentText => '링크';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? '파일' : '파일 $count개';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? '사진' : '사진 $count장';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? '동영상' : '동영상 $count개';

  @override
  String get pollYouVotedText => '투표했습니다';

  @override
  String pollSomeoneVotedText(String username) => '$username님이 투표했습니다';

  @override
  String get pollYouCreatedText => '생성했습니다';

  @override
  String pollSomeoneCreatedText(String username) => '$username님이 생성했습니다';

  @override
  String get draftLabel => '임시글';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return '실시간 위치';
    return '위치';
  }

  @override
  String get noConversationsYetText => '아직 대화가 없습니다';

  @override
  String get replyToStartThreadText => '스레드를 시작하려면 메시지에 답장하세요';

  @override
  String get sendMessageToStartConversationText => '대화를 시작하려면 메시지를 보내세요';

  @override
  String get savedForLaterLabel => '나중을 위해 저장됨';

  @override
  String get repliedToThreadAnnotationLabel => '스레드에 답장함';

  @override
  String get alsoSentInChannelAnnotationLabel => '채널에도 전송됨';

  @override
  String get viewLabel => '보기';

  @override
  String get reminderSetLabel => '리마인더 설정됨';

  @override
  String reminderAtText(String time) => '오늘 $time';

  @override
  String get createPollPromptLabel => '투표를 만들고 모두에게 투표하게 하세요!';

  @override
  String get takePhotoAndShareLabel => '사진을 찍고 공유';

  @override
  String get takeVideoAndShareLabel => '동영상을 찍고 공유';

  @override
  String get openCameraLabel => '카메라 열기';

  @override
  String get selectFilesToShareLabel => '공유할 파일 선택';

  @override
  String get openFilesLabel => '파일 열기';

  @override
  String get unsupportedAttachmentLabel => '지원되지 않는 첨부파일';

  @override
  String get confirmLabel => '확인';

  @override
  String get emptyReactionsText => '아직 반응이 없습니다';

  @override
  String get loadingReactionsError => '반응을 불러오는 중 오류가 발생했습니다';

  @override
  String get tapToRemoveReactionLabel => '탭하여 제거';

  @override
  String reactionsCountText(int count) => '반응 $count개';

  @override
  String get justNowLabel => '방금';

  @override
  String replyToUserLabel(String userName) => '$userName님에게 답장';

  @override
  String get multipleAnswersDescription => '여러 옵션 선택';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return '$min\u2013$max개의 옵션 중에서 선택';
  }

  @override
  String get anonymousPollDescription => '투표자 숨기기';

  @override
  String get suggestAnOptionDescription => '다른 사람이 옵션을 추가하도록 허용';

  @override
  String get addACommentDescription => '다른 사람이 댓글을 추가하도록 허용';

  @override
  String get notifyChannelText => '이 채널의 모든 사람에게 알림';

  @override
  String get notifyHereText => '이 채널의 모든 온라인 사용자에게 알림';

  @override
  String notifyRoleText(String role) => '모든 $role 멤버에게 알림';
}

class _AccessibilityTranslationsKo implements AccessibilityTranslations {
  const _AccessibilityTranslationsKo();

  @override
  String get localeName => 'ko';

  @override
  String get sendMessageTooltip => '메시지 보내기';

  @override
  String get saveEditTooltip => '편집 저장';

  @override
  String get sendCommandTooltip => '명령어 보내기';

  @override
  String slowModeTooltip({required int seconds}) {
    return '슬로모드: $seconds초';
  }

  @override
  String get recordVoiceRecordingLabel => '음성 메시지 녹음';

  @override
  String get cancelRecordingTooltip => '녹음 취소';

  @override
  String get stopRecordingTooltip => '녹음 중지';

  @override
  String get sendRecordingTooltip => '녹음 전송';

  @override
  String recordingDurationLabel({required Duration duration}) => '녹음 길이, ${formatDuration(duration)}';

  @override
  String voiceRecordingPreviewPlayLabel({required Duration duration}) => '음성 녹음 재생, ${formatDuration(duration)}';

  @override
  String voiceRecordingPreviewPauseLabel({required Duration duration}) => '음성 녹음 일시정지, ${formatDuration(duration)}';

  @override
  String get attachmentPickerTooltip => '첨부 파일 선택 열기';

  @override
  String get attachmentPickerOpenedAnnouncement => '첨부 파일 선택이 열렸습니다';

  @override
  String get attachmentPickerClosedAnnouncement => '첨부 파일 선택이 닫혔습니다';

  @override
  String voiceRecordingAttachmentLabel({Duration? duration}) {
    if (duration == null) return '음성 메시지';
    return '음성 메시지, ${formatDuration(duration)}';
  }

  @override
  String videoAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return '동영상';
    return '동영상, $title';
  }

  @override
  String get gifAttachmentLabel => 'GIF';

  @override
  String imageAttachmentLabel({String? title}) {
    if (title == null || title.isEmpty) return '사진';
    return '사진, $title';
  }

  @override
  String get voiceRecordingPlayTooltip => '재생';

  @override
  String get voiceRecordingPauseTooltip => '일시정지';

  @override
  String get voiceRecordingLoadingTooltip => '불러오는 중';

  @override
  String get channelInfoLabel => '채널 정보';

  @override
  String get messageActionsLabel => '메시지 작업';

  @override
  String galleryImageLabel({DateTime? createdAt}) {
    if (createdAt == null) return '사진';
    return '사진, ${formatDateTime(createdAt)}';
  }

  @override
  String galleryVideoLabel({
    DateTime? createdAt,
    Duration? duration,
  }) {
    final parts = <String>[
      '동영상',
      if (duration != null) formatDuration(duration),
      if (createdAt != null) formatDateTime(createdAt),
    ];
    return parts.join(', ');
  }

  @override
  String get selectMediaTapHint => '선택';

  @override
  String get deselectMediaTapHint => '선택 해제';

  @override
  String get savePollTooltip => '투표 저장';

  @override
  String removePollOptionTooltip({String? optionText}) {
    final trimmed = optionText?.trim();
    if (trimmed == null || trimmed.isEmpty) return '항목 삭제';
    return '항목 $trimmed 삭제';
  }

  @override
  String get recordingStartedAnnouncement => '녹음을 시작했습니다. 왼쪽으로 밀어 취소, 위로 밀어 잠그기.';

  @override
  String get recordingLockedAnnouncement => '녹음이 잠겼습니다';

  @override
  String get recordingStoppedAnnouncement => '녹음이 중지되었습니다';

  @override
  String get recordingCancelledAnnouncement => '녹음이 취소되었습니다';

  @override
  String get recordingCompletedAnnouncement => '녹음 완료';

  @override
  String get imageAttachmentAddedAnnouncement => '사진이 추가되었습니다';

  @override
  String get imageAttachmentRemovedAnnouncement => '사진이 삭제되었습니다';

  @override
  String get videoAttachmentAddedAnnouncement => '동영상이 추가되었습니다';

  @override
  String get videoAttachmentRemovedAnnouncement => '동영상이 삭제되었습니다';

  @override
  String get gifAttachmentAddedAnnouncement => 'GIF가 추가되었습니다';

  @override
  String get gifAttachmentRemovedAnnouncement => 'GIF가 삭제되었습니다';

  @override
  String get fileAttachmentAddedAnnouncement => '파일이 추가되었습니다';

  @override
  String get fileAttachmentRemovedAnnouncement => '파일이 삭제되었습니다';

  @override
  String get voiceRecordingAttachmentAddedAnnouncement => '음성 메시지가 추가되었습니다';

  @override
  String get voiceRecordingAttachmentRemovedAnnouncement => '음성 메시지가 삭제되었습니다';

  @override
  String get attachmentAddedAnnouncement => '첨부 파일이 추가되었습니다';

  @override
  String get attachmentRemovedAnnouncement => '첨부 파일이 삭제되었습니다';

  @override
  String attachmentsAddedAnnouncement({required int count}) {
    return '첨부 파일 $count개가 추가되었습니다';
  }

  @override
  String attachmentsRemovedAnnouncement({required int count}) {
    return '첨부 파일 $count개가 삭제되었습니다';
  }

  @override
  String formatDateTime(DateTime dateTime) {
    final jiffy = Jiffy.parseFromDateTime(dateTime);
    return '${jiffy.EEEE} ${jiffy.yMMMMd} ${jiffy.jm}';
  }

  @override
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    // Korean time-units have no grammatical number; comma-space between
    // parts gives the screen reader a pause between units.
    final parts = <String>[
      if (hours > 0) '$hours시간',
      if (minutes > 0) '$minutes분',
      if (seconds > 0 || (hours == 0 && minutes == 0)) '$seconds초',
    ];
    return parts.join(', ');
  }
}
