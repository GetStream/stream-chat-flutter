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
  String get onlyVisibleToYouText => '自分にのみ見えます';

  @override
  String threadReplyCountText(int count) => '$countつのスレッド返信';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) => '$remaining/${total}mbのアップロード中…';

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
  String get emptyMessagesText => '現在、メッセージはありません。';

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
  String get writeAMessageLabel => 'メッセージを書く';

  @override
  String get instantCommandsLabel => 'インスタントコマンド';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'ファイルのサイズが大きすぎてアップロードできません。'
      'ファイルサイズの制限は${limitInMB}MBです。'
      '圧縮を試しましたがサイズをオーバーしました';

  @override
  String fileTooLargeError(double limitInMB) => 'ファイルが大きすぎてアップロードできません。ファイルサイズの制限は${limitInMB}MBです。';

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
  String get addMoreFilesLabel => 'ファイルの追加';

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
  String get streamChatLabel => 'ストリームチャット';

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
  String get slowModeOnLabel => 'スローモードオン';

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
  String get questionsLabel => '問';

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
  String get endVoteConfirmationText => '投票を終了してもよろしいですか？';

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
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'すべての投票を表示';
    return 'すべての $count 投票を表示';
  }

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 票',
    1 => '1 票',
    _ => '$count 票',
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
    if (isLive) return '📍 ライブ位置情報';
    return '📍 位置情報';
  }
}
