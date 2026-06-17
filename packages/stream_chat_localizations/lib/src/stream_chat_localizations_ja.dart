part of 'stream_chat_localizations.dart';

/// The translations for Japanese (`ja`).
class StreamChatLocalizationsJa extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Japanese.
  const StreamChatLocalizationsJa({super.localeName = 'ja'});

  @override
  String get launchUrlError => 'URLの起動ができません';

  @override
  String get loadingUsersError => 'ユーザーの読み込みができません';

  @override
  String get noUsersLabel => '現在、ユーザーはいません。';

  @override
  String get noPhotoOrVideoLabel => '写真やビデオはありません';

  @override
  String get retryLabel => '再試行';

  @override
  String get userLastOnlineText => '前回のオンライン';

  @override
  String get userOnlineText => 'オンライン';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name}が入力しています';
    }
    return '${first.name}と${users.length - 1}人が入力しています';
  }

  @override
  String get threadReplyLabel => 'スレッド返信';

  @override
  String get threadLabel => 'スレッド';

  @override
  String get onlyVisibleToYouText => '自分にのみ見えます';

  @override
  String threadReplyCountText(int count) => '$countつのスレッド返信';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => '$total 件中 $completed 件アップロード済み…';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'あなたのピン';
    return '${pinnedBy.name}のピン';
  }

  @override
  String get sendMessagePermissionError => 'メッセージを送信する権限がありません';

  @override
  String get emptyMessagesText => 'メッセージはまだありません';

  @override
  String get genericErrorText => 'エラーが発生しました';

  @override
  String get loadingMessagesError => 'メッセージの読み込みエラー';

  @override
  String resultCountText(int count) => '$count件の結果';

  @override
  String get messageDeletedText => 'このメッセージは削除されました。';

  @override
  String get messageDeletedLabel => 'メッセージ削除';

  @override
  String get systemMessageLabel => 'システムメッセージ';

  @override
  String get editedMessageLabel => '編集済み';

  @override
  String get messageReactionsLabel => 'メッセージのリアクション';

  @override
  String get emptyChatMessagesText => 'まだメッセージはありません…';

  @override
  String threadSeparatorText(int replyCount) => '$replyCount件の返信';

  @override
  String get connectedLabel => '接続しています';

  @override
  String get disconnectedLabel => '接続切れ';

  @override
  String get reconnectingLabel => '再接続中…';

  @override
  String get alsoSendAsDirectMessageLabel => 'ダイレクトメッセージでも送信';

  @override
  String get addACommentOrSendLabel => 'コメントの追加や送信';

  @override
  String get searchGifLabel => 'GIFの検索';

  @override
  String get writeAMessageLabel => 'メッセージを送る';

  @override
  String get instantCommandsLabel => 'インスタントコマンド';

  @override
  String get commandUnavailableWhileEditingError => 'Not available while editing';

  @override
  String get commandUnavailableWhileQuotingError => 'Not available while replying';

  @override
  String get commandUnavailableError => 'Command not available';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'ファイルのサイズが大きすぎてアップロードできません。'
      'ファイルサイズの制限は${limitInMB}MBです。'
      '圧縮を試しましたがサイズをオーバーしました';

  @override
  String fileTooLargeError(double limitInMB) => 'ファイルが大きすぎてアップロードできません。ファイルサイズの制限は${limitInMB}MBです。';

  @override
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) return "'.$extension'ファイルはアップロードに対応していません。";
    return 'このファイル形式はアップロードに対応していません。';
  }

  @override
  String get couldNotReadBytesFromFileError => 'ファイルからバイトを読み取れませんでした';

  @override
  String get addAFileLabel => 'ファイルの追加';

  @override
  String get photoFromCameraLabel => 'カメラからの写真';

  @override
  String get uploadAFileLabel => 'ファイルのアップロード';

  @override
  String get uploadAPhotoLabel => '写真のアップロード';

  @override
  String get uploadAVideoLabel => '動画のアップロード';

  @override
  String get videoFromCameraLabel => 'カメラからの動画';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'エラーが発生しました';

  @override
  String get addMoreFilesLabel => 'さらに追加';

  @override
  String get enablePhotoAndVideoAccessMessage => 'お友達と共有できるように、写真やビデオへのアクセスを有効にしてください。';
  @override
  String get allowGalleryAccessMessage => 'ギャラリーへのアクセスを許可する';

  @override
  String get flagMessageLabel => 'メッセージをフラグする';

  @override
  String get flagMessageQuestion => 'このメッセージのコピーをモデレーターに送って、さらに調査してもらいますか？';

  @override
  String get flagLabel => 'フラグする';

  @override
  String get cancelLabel => 'キャンセル';

  @override
  String get flagMessageSuccessfulLabel => 'メッセージにフラグが付けられました';

  @override
  String get flagMessageSuccessfulText => 'このメッセージはモデレーターに報告されました。';

  @override
  String get deleteLabel => '削除';

  @override
  String get deleteMessageLabel => 'メッセージを削除する';

  @override
  String get deleteMessageQuestion => 'このメッセージを完全に削除してもよろしいですか？';

  @override
  String get operationCouldNotBeCompletedText => '操作を完了できませんでした。';

  @override
  String get replyLabel => '返信';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return '会話のピンを外す';
    return '会話をピンする';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'メッセージの削除を再試行する';
    return 'メッセージを削除する';
  }

  @override
  String get copyMessageLabel => 'メッセージをコピーする';

  @override
  String get editMessageLabel => 'メッセージを編集する';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return '編集したメッセージを再送する';
    return '再送';
  }

  @override
  String get photosLabel => '写真';

  @override
  String get photosAndVideosLabel => '写真と動画';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return '今日';
    } else if (date == yesterday) {
      return '昨日';
    } else {
      return '${Jiffy.parseFromDateTime(date).MMMd}に';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return '${_getDay(date)}の${atTime.jm}に送信しました ';
  }

  @override
  String get todayLabel => '今日';

  @override
  String get yesterdayLabel => '昨日';

  @override
  String get channelIsMutedText => 'チャンネルがミュートされています';

  @override
  String get noTitleText => 'タイトル無し';

  @override
  String get letsStartChattingLabel => 'チャットを始めよう！';

  @override
  String get sendingFirstMessageLabel => '最初のメッセージを送ってみましょう';

  @override
  String get startAChatLabel => 'チャットを開始する';

  @override
  String get loadingChannelsError => 'チャネルのロード中にエラーが発生しました';

  @override
  String get deleteConversationLabel => '会話を削除する';

  @override
  String get deleteConversationQuestion => '本当に会話を削除しますか？';

  @override
  String get streamChatLabel => 'チャット';

  @override
  String get searchingForNetworkText => 'ネットワークを検索中';

  @override
  String get offlineLabel => 'オフライン…';

  @override
  String get tryAgainLabel => '再試行する';

  @override
  String membersCountText(int count) => '$count人のメンバー';

  @override
  String watchersCountText(int count) => '$count人がオンライン';

  @override
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members、${watchersCountText(onlineCount)}';
  }

  @override
  String get viewInfoLabel => '情報を見る';

  @override
  String get leaveGroupLabel => 'グループから退出する';

  @override
  String get leaveLabel => '退出する';

  @override
  String get leaveConversationLabel => '会話から退出する';

  @override
  String get leaveConversationQuestion => '本当に会話から退出しますか？';

  @override
  String get showInChatLabel => 'チャットで表示';

  @override
  String get saveImageLabel => '画像を保存';

  @override
  String get saveVideoLabel => 'ビデオを保存';

  @override
  String get uploadErrorLabel => 'アップロードエラー';

  @override
  String get giphyLabel => 'GIPHY';

  @override
  String get shuffleLabel => 'ミックス';

  @override
  String get sendLabel => '送信';

  @override
  String get withText => 'と';

  @override
  String get inText => 'に';

  // This is the word for 'customer' or 'user' because saying 'you' directly
  //is too informal and rude
  @override
  String get youText => 'あなた';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) => '${currentPage + 1} / $totalPages';

  @override
  String get fileText => 'ファイル';

  @override
  String get replyToMessageLabel => 'メッセージに返信';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'スローモード、$cooldownTimeOut秒お待ちください\u2026';

  @override
  String get commandUsernameLabel => '@username';

  @override
  String get viewLibrary => 'ライブラリを表示';

  @override
  String attachmentLimitExceedError(int limit) =>
      '''
添付ファイルの制限を超えました：$limit個のファイル以上を添付することはできません
  ''';

  @override
  String get downloadLabel => 'ダウンロード';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'ユーザーのミュートを解除する';
    } else {
      return 'ユーザーをミュート';
    }
  }

  @override
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'ユーザーのブロックを解除';
    return 'ユーザーをブロック';
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'このグループのミュートを解除してもよろしいですか？';
    } else {
      return 'このグループをミュートしてもよろしいですか？';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'このユーザーのミュートを解除してもよろしいですか？';
    } else {
      return 'このユーザーをミュートしてもよろしいですか？';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'ミュートを解除する';
    } else {
      return 'ミュート';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'グループのミュートを解除';
    } else {
      return 'ミュートグループ';
    }
  }

  @override
  String get linkDisabledDetails => 'この会話では、リンクの送信は許可されていません。';

  @override
  String get linkDisabledError => 'リンクが無効になっています';

  @override
  String unreadMessagesSeparatorText() => '新しいメッセージ。';

  @override
  String get enableFileAccessMessage => '友達と共有できるように、ファイルへのアクセスを有効にしてください。';

  @override
  String get allowFileAccessMessage => 'ファイルへのアクセスを許可する';

  @override
  String get markAsUnreadLabel => '未読としてマーク';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount 未読';
  }

  @override
  String get markUnreadError => 'メッセージを未読にする際にエラーが発生しました。最新の100件のチャンネルメッセージより古い未読メッセージはマークできません。';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return '新しい投票を作成する';
    return '投票の作成';
  }

  @override
  String questionLabel({bool isPlural = false}) => '問';

  @override
  String get askAQuestionLabel => '質問する';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return '質問は $min 文字以上である必要があります';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return '質問の長さは最大$max文字にする必要があります';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'オプション';
    return 'オプション';
  }

  @override
  String get pollOptionEmptyError => 'オプションを空にすることはできません';

  @override
  String get pollOptionDuplicateError => 'これはすでにオプションです';

  @override
  String get addAnOptionLabel => 'オプションを追加する';

  @override
  String get multipleAnswersLabel => '複数の回答';

  @override
  String get maximumVotesPerPersonLabel => '一人当たりの最大投票数';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return '投票数は$min以上である必要があります';
    }

    if (max != null && votes > max) {
      return '投票数は最大$max票でなければなりません';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => '匿名投票';

  @override
  String get pollOptionsLabel => '投票オプション';

  @override
  String get suggestAnOptionLabel => 'オプションを提案';

  @override
  String get enterANewOptionLabel => '新しいオプションを入力';

  @override
  String get addACommentLabel => 'コメントを追加';

  @override
  String get pollCommentsLabel => '投票コメント';

  @override
  String get updateYourCommentLabel => 'コメントを更新';

  @override
  String get enterYourCommentLabel => 'コメントを入力';

  @override
  String get endVoteConfirmationTitle => '投票を終了してもよろしいですか？';

  @override
  String get endVoteConfirmationMessage => 'この投票を今すぐ終了しますか？終了後は誰も投票できなくなります。';

  @override
  String get deletePollOptionLabel => 'オプションを削除する';

  @override
  String get deletePollOptionQuestion => 'このオプションを削除してもよろしいですか？';

  @override
  String get createLabel => '作成';

  @override
  String get endLabel => '終了';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => '投票終了',
      unique: () => '1つを選択',
      limited: (count) => '最大 $count 選択',
      all: () => '1つ以上を選択',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'すべてのオプションを表示';
    return 'すべての $count オプションを表示';
  }

  @override
  String get viewCommentsLabel => 'コメントを表示';

  @override
  String get viewResultsLabel => '結果を表示';

  @override
  String get endVoteLabel => '投票を終了';

  @override
  String get pollResultsLabel => '投票結果';

  @override
  String get pollVotesLabel => '投票';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'すべての投票を表示';
    return 'すべての $count 投票を表示';
  }

  @override
  String get viewAllLabel => 'すべて表示';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 票',
    1 => '1 票',
    _ => '$count 票',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '合計 0 票',
    1 => '合計 1 票',
    _ => '合計 $count 票',
  };

  @override
  String get noPollVotesLabel => '現在投票はありません';

  @override
  String get loadingPollVotesError => '投票の読み込みエラー';

  @override
  String get repliedToLabel => '返信先:';

  @override
  String newThreadsLabel({required int count}) {
    return '$count 件の新しいスレッド';
  }

  @override
  String get loadingLabel => '読み込み中...';

  @override
  String get slideToCancelLabel => 'スライドでキャンセル';

  @override
  String get holdToRecordLabel => '長押しで録音、離すと送信';

  @override
  String get sendAnywayLabel => 'それでも送信';

  @override
  String get moderatedMessageBlockedText => 'メッセージはモデレーションポリシーによってブロックされました';

  @override
  String get moderationReviewModalTitle => 'よろしいですか？';

  @override
  String get moderationReviewModalDescription => '''あなたのコメントが他の人にどのような影響を与えるかを考え、コミュニティガイドラインに従ってください。''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => '音声録音';

  @override
  String get audioAttachmentText => 'オーディオ';

  @override
  String get imageAttachmentText => '画像';

  @override
  String get videoAttachmentText => '動画';

  @override
  String get fileAttachmentText => 'ファイル';

  @override
  String get linkAttachmentText => 'リンク';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'ファイル' : '$count件のファイル';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? '写真' : '$count枚の写真';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? '動画' : '$count本の動画';

  @override
  String get pollYouVotedText => '投票しました';

  @override
  String pollSomeoneVotedText(String username) => '$usernameが投票しました';

  @override
  String get pollYouCreatedText => 'あなたが作成しました';

  @override
  String pollSomeoneCreatedText(String username) => '$usernameが作成しました';

  @override
  String get draftLabel => '下書き';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'ライブ位置情報';
    return '位置情報';
  }

  @override
  String get noConversationsYetText => 'まだ会話がありません';

  @override
  String get replyToStartThreadText => 'スレッドを開始するにはメッセージに返信してください';

  @override
  String get sendMessageToStartConversationText => '会話を始めるにはメッセージを送信してください';

  @override
  String get savedForLaterLabel => '後で確認';

  @override
  String get repliedToThreadAnnotationLabel => 'スレッドに返信しました';

  @override
  String get alsoSentInChannelAnnotationLabel => 'チャンネルにも送信されました';

  @override
  String get viewLabel => '表示';

  @override
  String get reminderSetLabel => 'リマインダー設定済み';

  @override
  String reminderAtText(String time) => '今日 $time';

  @override
  String get createPollPromptLabel => '投票を作成してみんなに投票してもらおう！';

  @override
  String get takePhotoAndShareLabel => '写真を撮って共有';

  @override
  String get takeVideoAndShareLabel => '動画を撮って共有';

  @override
  String get openCameraLabel => 'カメラを開く';

  @override
  String get selectFilesToShareLabel => '共有するファイルを選択';

  @override
  String get openFilesLabel => 'ファイルを開く';

  @override
  String get unsupportedAttachmentLabel => 'サポートされていない添付ファイル';

  @override
  String get confirmLabel => '確認';

  @override
  String get emptyReactionsText => 'まだリアクションはありません';

  @override
  String get loadingReactionsError => 'リアクションの読み込み中にエラーが発生しました';

  @override
  String get tapToRemoveReactionLabel => 'タップして削除';

  @override
  String reactionsCountText(int count) => '$count件のリアクション';

  @override
  String get justNowLabel => 'たった今';

  @override
  String replyToUserLabel(String userName) => '$userNameに返信';

  @override
  String get multipleAnswersDescription => '複数の選択肢を選ぶ';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return '$min〜$max個の選択肢から選ぶ';
  }

  @override
  String get anonymousPollDescription => '投票者を非表示';

  @override
  String get suggestAnOptionDescription => '他のユーザーに選択肢の追加を許可';

  @override
  String get addACommentDescription => '他のユーザーにコメントの追加を許可';
}
