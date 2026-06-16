// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Russian (`ru`).
class StreamChatLocalizationsRu extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Russian.
  const StreamChatLocalizationsRu({super.localeName = 'ru'});

  /// Selects the correct Russian plural form for [count].
  ///
  /// Russian has three plural forms: [one] (e.g. 1, 21, 31), [few]
  /// (e.g. 2, 3, 4, 22) and [many] (e.g. 5, 11, 12, 25).
  String _plural(
    int count, {
    required String one,
    required String few,
    required String many,
  }) {
    final mod10 = count % 10;
    final mod100 = count % 100;
    if (mod10 == 1 && mod100 != 11) return one;
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return few;
    return many;
  }

  @override
  String get launchUrlError => 'Не удалось открыть ссылку';

  @override
  String get loadingUsersError => 'Ошибка загрузки пользователей';

  @override
  String get noUsersLabel => 'Сейчас нет пользователей';

  @override
  String get noPhotoOrVideoLabel => 'Нет фото или видео';

  @override
  String get retryLabel => 'Повторить';

  @override
  String get userLastOnlineText => 'Был(а) в сети';

  @override
  String get userOnlineText => 'В сети';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} печатает';
    }
    return '${first.name} и ещё ${users.length - 1} печатают';
  }

  @override
  String get threadReplyLabel => 'Ответ в треде';

  @override
  String get threadLabel => 'Тред';

  @override
  String get onlyVisibleToYouText => 'Видно только вам';

  @override
  String threadReplyCountText(int count) => '$count ${_plural(count, one: 'ответ', few: 'ответа', many: 'ответов')}';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => 'Загружено $completed из $total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Закреплено вами';
    return 'Закреплено ${pinnedBy.name}';
  }

  @override
  String get sendMessagePermissionError => 'У вас нет разрешения отправлять сообщения';

  @override
  String get emptyMessagesText => 'Сообщений пока нет';

  @override
  String get genericErrorText => 'Что-то пошло не так';

  @override
  String get loadingMessagesError => 'Ошибка загрузки сообщений';

  @override
  String resultCountText(int count) =>
      '$count ${_plural(count, one: 'результат', few: 'результата', many: 'результатов')}';

  @override
  String get messageDeletedText => 'Это сообщение удалено.';

  @override
  String get messageDeletedLabel => 'Сообщение удалено';

  @override
  String get systemMessageLabel => 'Системное сообщение';

  @override
  String get editedMessageLabel => 'Изменено';

  @override
  String get messageReactionsLabel => 'Реакции на сообщение';

  @override
  String get emptyChatMessagesText => 'Здесь пока нет чатов...';

  @override
  String threadSeparatorText(int replyCount) =>
      '$replyCount ${_plural(replyCount, one: 'ответ', few: 'ответа', many: 'ответов')}';

  @override
  String get connectedLabel => 'Подключено';

  @override
  String get disconnectedLabel => 'Отключено';

  @override
  String get reconnectingLabel => 'Переподключение...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Также отправить в канал';

  @override
  String get addACommentOrSendLabel => 'Добавьте комментарий или отправьте';

  @override
  String get searchGifLabel => 'Поиск GIF';

  @override
  String get writeAMessageLabel => 'Отправить сообщение';

  @override
  String get instantCommandsLabel => 'Быстрые команды';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'Файл слишком большой для загрузки. '
      'Ограничение размера файла — $limitInMB МБ. '
      'Мы попытались сжать его, но этого оказалось недостаточно.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'Файл слишком большой для загрузки. Ограничение размера файла — $limitInMB МБ.';

  @override
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) {
      return 'Файлы «.$extension» не поддерживаются для загрузки.';
    }
    return 'Этот тип файла не поддерживается для загрузки.';
  }

  @override
  String get couldNotReadBytesFromFileError => 'Не удалось прочитать байты из файла.';

  @override
  String get addAFileLabel => 'Добавить файл';

  @override
  String get photoFromCameraLabel => 'Фото с камеры';

  @override
  String get uploadAFileLabel => 'Загрузить файл';

  @override
  String get uploadAPhotoLabel => 'Загрузить фото';

  @override
  String get uploadAVideoLabel => 'Загрузить видео';

  @override
  String get videoFromCameraLabel => 'Видео с камеры';

  @override
  String get okLabel => 'ОК';

  @override
  String get somethingWentWrongError => 'Что-то пошло не так';

  @override
  String get addMoreFilesLabel => 'Добавить ещё';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Пожалуйста, разрешите доступ к фото и видео, чтобы делиться ими с друзьями.';

  @override
  String get allowGalleryAccessMessage => 'Разрешить доступ к галерее';

  @override
  String get flagMessageLabel => 'Пожаловаться на сообщение';

  @override
  String get flagMessageQuestion => 'Хотите отправить копию этого сообщения модератору для дальнейшего рассмотрения?';

  @override
  String get flagLabel => 'Пожаловаться';

  @override
  String get cancelLabel => 'Отмена';

  @override
  String get flagMessageSuccessfulLabel => 'Жалоба отправлена';

  @override
  String get flagMessageSuccessfulText => 'Сообщение отправлено модератору.';

  @override
  String get deleteLabel => 'Удалить';

  @override
  String get deleteMessageLabel => 'Удалить сообщение';

  @override
  String get deleteMessageQuestion => 'Вы уверены, что хотите безвозвратно удалить это сообщение?';

  @override
  String get operationCouldNotBeCompletedText => 'Не удалось выполнить операцию.';

  @override
  String get replyLabel => 'Ответить';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Открепить от беседы';
    return 'Закрепить в беседе';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Повторить удаление сообщения';
    return 'Удалить сообщение';
  }

  @override
  String get copyMessageLabel => 'Копировать сообщение';

  @override
  String get editMessageLabel => 'Редактировать сообщение';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Отправить изменённое сообщение';
    return 'Отправить повторно';
  }

  @override
  String get photosLabel => 'Фото';

  @override
  String get photosAndVideosLabel => 'Фото и видео';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'сегодня';
    } else if (date == yesterday) {
      return 'вчера';
    } else {
      return Jiffy.parseFromDateTime(date).MMMd;
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Отправлено ${_getDay(date)} в ${atTime.jm}';
  }

  @override
  String get todayLabel => 'Сегодня';

  @override
  String get yesterdayLabel => 'Вчера';

  @override
  String get channelIsMutedText => 'Канал без звука';

  @override
  String get noTitleText => 'Без названия';

  @override
  String get letsStartChattingLabel => 'Давайте начнём общение!';

  @override
  String get sendingFirstMessageLabel => 'Как насчёт того, чтобы отправить первое сообщение другу?';

  @override
  String get startAChatLabel => 'Начать чат';

  @override
  String get loadingChannelsError => 'Ошибка загрузки каналов';

  @override
  String get deleteConversationLabel => 'Удалить беседу';

  @override
  String get deleteConversationQuestion => 'Вы уверены, что хотите удалить эту беседу?';

  @override
  String get streamChatLabel => 'Чаты';

  @override
  String get searchingForNetworkText => 'Поиск сети';

  @override
  String get offlineLabel => 'Не в сети...';

  @override
  String get tryAgainLabel => 'Повторить';

  @override
  String membersCountText(int count) =>
      '$count ${_plural(count, one: 'участник', few: 'участника', many: 'участников')}';

  @override
  String watchersCountText(int count) => '$count в сети';

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
  String get viewInfoLabel => 'Просмотр информации';

  @override
  String get leaveGroupLabel => 'Покинуть группу';

  @override
  String get leaveLabel => 'ПОКИНУТЬ';

  @override
  String get leaveConversationLabel => 'Покинуть беседу';

  @override
  String get leaveConversationQuestion => 'Вы уверены, что хотите покинуть эту беседу?';

  @override
  String get showInChatLabel => 'Показать в чате';

  @override
  String get saveImageLabel => 'Сохранить изображение';

  @override
  String get saveVideoLabel => 'Сохранить видео';

  @override
  String get uploadErrorLabel => 'ОШИБКА ЗАГРУЗКИ';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Перемешать';

  @override
  String get sendLabel => 'Отправить';

  @override
  String get withText => 'с';

  @override
  String get inText => 'в';

  @override
  String get youText => 'Вы';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) => '${currentPage + 1} из $totalPages';

  @override
  String get fileText => 'Файл';

  @override
  String get replyToMessageLabel => 'Ответить на сообщение';

  @override
  String attachmentLimitExceedError(int limit) => 'Превышен лимит вложений, лимит: $limit';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'Медленный режим, подождите $cooldownTimeOut с…';

  @override
  String get commandUsernameLabel => '@имя_пользователя';

  @override
  String get downloadLabel => 'Скачать';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'Включить звук пользователя';
    } else {
      return 'Отключить звук пользователя';
    }
  }

  @override
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'Разблокировать пользователя';
    return 'Заблокировать пользователя';
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Вы уверены, что хотите включить звук в этой группе?';
    } else {
      return 'Вы уверены, что хотите отключить звук в этой группе?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Вы уверены, что хотите включить звук этого пользователя?';
    } else {
      return 'Вы уверены, что хотите отключить звук этого пользователя?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'ВКЛ. ЗВУК';
    } else {
      return 'ВЫКЛ. ЗВУК';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Включить звук группы';
    } else {
      return 'Отключить звук группы';
    }
  }

  @override
  String get linkDisabledDetails => 'Отправка ссылок запрещена в этой беседе.';

  @override
  String get linkDisabledError => 'Ссылки отключены';

  @override
  String get viewLibrary => 'Открыть библиотеку';

  @override
  String unreadMessagesSeparatorText() => 'Новые сообщения';

  @override
  String get enableFileAccessMessage => 'Пожалуйста, разрешите доступ к файлам, чтобы делиться ими с друзьями.';

  @override
  String get allowFileAccessMessage => 'Разрешить доступ к файлам';

  @override
  String get markAsUnreadLabel => 'Отметить непрочитанным';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) =>
      '$unreadCount ${_plural(unreadCount, one: 'непрочитанное', few: 'непрочитанных', many: 'непрочитанных')}';

  @override
  String get markUnreadError =>
      'Ошибка при отметке сообщения непрочитанным. Нельзя отметить '
      'непрочитанными сообщения старше последних 100 сообщений канала.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Создать новый опрос';
    return 'Создать опрос';
  }

  @override
  String questionLabel({bool isPlural = false}) {
    if (isPlural) return 'Вопросы';
    return 'Вопрос';
  }

  @override
  String get askAQuestionLabel => 'Задайте вопрос';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && length < min) {
      return 'Вопрос должен содержать не менее $min символов';
    }

    if (max != null && length > max) {
      return 'Вопрос должен содержать не более $max символов';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Варианты';
    return 'Вариант';
  }

  @override
  String get pollOptionEmptyError => 'Вариант не может быть пустым';

  @override
  String get pollOptionDuplicateError => 'Такой вариант уже есть';

  @override
  String get addAnOptionLabel => 'Добавить вариант';

  @override
  String get multipleAnswersLabel => 'Несколько ответов';

  @override
  String get maximumVotesPerPersonLabel => 'Максимум голосов на человека';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Количество голосов должно быть не менее $min';
    }

    if (max != null && votes > max) {
      return 'Количество голосов должно быть не более $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Анонимный опрос';

  @override
  String get pollOptionsLabel => 'Варианты опроса';

  @override
  String get suggestAnOptionLabel => 'Предложить вариант';

  @override
  String get enterANewOptionLabel => 'Введите новый вариант';

  @override
  String get addACommentLabel => 'Добавить комментарий';

  @override
  String get pollCommentsLabel => 'Комментарии к опросу';

  @override
  String get updateYourCommentLabel => 'Обновите ваш комментарий';

  @override
  String get enterYourCommentLabel => 'Введите ваш комментарий';

  @override
  String get endVoteConfirmationTitle => 'Завершить опрос?';

  @override
  String get endVoteConfirmationMessage =>
      'Хотите завершить этот опрос сейчас? После этого никто не сможет в нём голосовать.';

  @override
  String get deletePollOptionLabel => 'Удалить вариант';

  @override
  String get deletePollOptionQuestion => 'Вы уверены, что хотите удалить этот вариант?';

  @override
  String get createLabel => 'Создать';

  @override
  String get endLabel => 'Завершить';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Голосование завершено',
      unique: () => 'Выберите один',
      limited: (count) => 'Выберите до $count',
      all: () => 'Выберите один или несколько',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Посмотреть все варианты';
    return 'Посмотреть все $count ${_plural(count, one: 'вариант', few: 'варианта', many: 'вариантов')}';
  }

  @override
  String get viewCommentsLabel => 'Посмотреть комментарии';

  @override
  String get viewResultsLabel => 'Посмотреть результаты';

  @override
  String get endVoteLabel => 'Завершить опрос';

  @override
  String get pollResultsLabel => 'Результаты опроса';

  @override
  String get pollVotesLabel => 'Голоса';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Показать все голоса';
    return 'Показать все $count ${_plural(count, one: 'голос', few: 'голоса', many: 'голосов')}';
  }

  @override
  String get viewAllLabel => 'Показать все';

  @override
  String voteCountLabel({int? count}) {
    final c = count ?? 0;
    if (c < 1) return '0 голосов';
    return '$c ${_plural(c, one: 'голос', few: 'голоса', many: 'голосов')}';
  }

  @override
  String totalVoteCountLabel({int? count}) {
    final c = count ?? 0;
    if (c < 1) return 'всего 0 голосов';
    return 'всего $c ${_plural(c, one: 'голос', few: 'голоса', many: 'голосов')}';
  }

  @override
  String get noPollVotesLabel => 'Сейчас нет голосов';

  @override
  String get loadingPollVotesError => 'Ошибка загрузки голосов';

  @override
  String get repliedToLabel => 'ответил(а):';

  @override
  String newThreadsLabel({required int count}) =>
      '$count ${_plural(count, one: 'новый тред', few: 'новых треда', many: 'новых тредов')}';

  @override
  String get loadingLabel => 'Загрузка...';

  @override
  String get slideToCancelLabel => 'Проведите, чтобы отменить';

  @override
  String get holdToRecordLabel => 'Удерживайте для записи. Отпустите для сохранения.';

  @override
  String get sendAnywayLabel => 'Всё равно отправить';

  @override
  String get moderatedMessageBlockedText => 'Сообщение заблокировано правилами модерации';

  @override
  String get moderationReviewModalTitle => 'Вы уверены?';

  @override
  String get moderationReviewModalDescription =>
      '''Подумайте, как ваш комментарий может повлиять на других, и обязательно следуйте нашим правилам сообщества.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Голосовое сообщение';

  @override
  String get audioAttachmentText => 'Аудио';

  @override
  String get imageAttachmentText => 'Изображение';

  @override
  String get videoAttachmentText => 'Видео';

  @override
  String get fileAttachmentText => 'Файл';

  @override
  String get linkAttachmentText => 'Ссылка';

  @override
  String filesAttachmentCountText(int count) =>
      count == 1 ? 'Файл' : '$count ${_plural(count, one: 'файл', few: 'файла', many: 'файлов')}';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Фото' : '$count фото';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Видео' : '$count видео';

  @override
  String get pollYouVotedText => 'Вы проголосовали';

  @override
  String pollSomeoneVotedText(String username) => '$username проголосовал(а)';

  @override
  String get pollYouCreatedText => 'Вы создали';

  @override
  String pollSomeoneCreatedText(String username) => '$username создал(а)';

  @override
  String get draftLabel => 'Черновик';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'Трансляция геопозиции';
    return 'Геопозиция';
  }

  @override
  String get noConversationsYetText => 'Пока нет бесед';

  @override
  String get replyToStartThreadText => 'Ответьте на сообщение, чтобы начать тред';

  @override
  String get sendMessageToStartConversationText => 'Отправьте сообщение, чтобы начать беседу';

  @override
  String get savedForLaterLabel => 'Сохранено на потом';

  @override
  String get repliedToThreadAnnotationLabel => 'Ответил(а) в треде';

  @override
  String get alsoSentInChannelAnnotationLabel => 'Также отправлено в канал';

  @override
  String get viewLabel => 'Просмотр';

  @override
  String get reminderSetLabel => 'Напоминание установлено';

  @override
  String reminderAtText(String time) => 'Сегодня в $time';

  @override
  String get createPollPromptLabel => 'Создайте опрос, и пусть все проголосуют!';

  @override
  String get takePhotoAndShareLabel => 'Сделайте фото и поделитесь';

  @override
  String get takeVideoAndShareLabel => 'Снимите видео и поделитесь';

  @override
  String get openCameraLabel => 'Открыть камеру';

  @override
  String get selectFilesToShareLabel => 'Выберите файлы, чтобы поделиться';

  @override
  String get openFilesLabel => 'Открыть файлы';

  @override
  String get unsupportedAttachmentLabel => 'Неподдерживаемое вложение';

  @override
  String get confirmLabel => 'ПОДТВЕРДИТЬ';

  @override
  String get emptyReactionsText => 'Пока нет реакций';

  @override
  String get loadingReactionsError => 'Ошибка загрузки реакций';

  @override
  String get tapToRemoveReactionLabel => 'Нажмите, чтобы убрать';

  @override
  String reactionsCountText(int count) => '$count ${_plural(count, one: 'реакция', few: 'реакции', many: 'реакций')}';

  @override
  String get justNowLabel => 'Только что';

  @override
  String replyToUserLabel(String userName) => 'Ответить $userName';

  @override
  String get multipleAnswersDescription => 'Выберите более одного варианта';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return 'Выберите от $min до $max вариантов';
  }

  @override
  String get anonymousPollDescription => 'Скрыть, кто голосовал';

  @override
  String get suggestAnOptionDescription => 'Разрешить другим добавлять варианты';

  @override
  String get addACommentDescription => 'Разрешить другим оставлять комментарии';
}
