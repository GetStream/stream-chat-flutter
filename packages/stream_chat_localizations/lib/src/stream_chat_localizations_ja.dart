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
  }) =>
      '$remaining/${total}mbのアップロード中…';

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
  String fileTooLargeError(double limitInMB) =>
      'ファイルが大きすぎてアップロードできません。ファイルサイズの制限は${limitInMB}MBです。';

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
  String get enablePhotoAndVideoAccessMessage => 'お友達と共有できるように、写真'
      '\nやビデオへのアクセスを有効にしてください。';
  @override
  String get allowGalleryAccessMessage => 'ギャラリーへのアクセスを許可する';

  @override
  String get flagMessageLabel => 'メッセージをフラグする';

  @override
  String get flagMessageQuestion => 'このメッセージのコピーを'
      '\nモデレーターに送って、さらに調査してもらいますか？';

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
  String get deleteMessageQuestion => 'このメッセージ'
      '\nを完全に削除してもよろしいですか？';

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
      return '${Jiffy(date).MMMd}に';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '${_getDay(date)}の${Jiffy(time.toLocal()).format('HH:mm')}に送信しました ';

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
  }) =>
      '${currentPage + 1} / $totalPages';

  @override
  String get fileText => 'ファイル';

  @override
  String get replyToMessageLabel => 'メッセージに返信';

  @override
  String get slowModeOnLabel => 'スローモードオン';

  @override
  String get viewLibrary => 'ライブラリを表示';

  @override
  String attachmentLimitExceedError(int limit) => '''
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
  String unreadMessagesSeparatorText(int unreadCount) {
    if (unreadCount == 1) {
      return '未読メッセージ1通';
    }
    return '$unreadCountつの未読メッセージ';
  }

  @override
  String get enableFileAccessMessage =>
      '友達と共有できるように、' '\nファイルへのアクセスを有効にしてください。';

  @override
  String get allowFileAccessMessage => 'ファイルへのアクセスを許可する';
}
