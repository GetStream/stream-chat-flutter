// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Azerbaijani (`az`).
class StreamChatLocalizationsAz extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Azerbaijani.
  const StreamChatLocalizationsAz({super.localeName = 'az'});

  @override
  String get launchUrlError => 'URL-ni açmaq mümkün olmadı';

  @override
  String get loadingUsersError => 'İstifadəçilər yüklənərkən xəta baş verdi';

  @override
  String get noUsersLabel => 'Hal-hazırda istifadəçi yoxdur';

  @override
  String get noPhotoOrVideoLabel => 'Foto və ya video yoxdur';

  @override
  String get retryLabel => 'Yenidən cəhd et';

  @override
  String get userLastOnlineText => 'Son onlayn';

  @override
  String get userOnlineText => 'Onlayn';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} yazır';
    }
    return '${first.name} və daha ${users.length - 1} nəfər yazır';
  }

  @override
  String get threadReplyLabel => 'Mövzuya cavab';

  @override
  String get threadLabel => 'Mövzu';

  @override
  String get onlyVisibleToYouText => 'Yalnız sizə görünür';

  @override
  String threadReplyCountText(int count) => count == 1 ? '1 cavab' : '$count cavab';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) =>
      '$total-dən $completed yükləndi ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Siz sabitlədiniz';
    return '${pinnedBy.name} sabitlədi';
  }

  @override
  String get sendMessagePermissionError => 'Mesaj göndərmək üçün icazəniz yoxdur';

  @override
  String get emptyMessagesText => 'Hələ mesaj yoxdur';

  @override
  String get genericErrorText => 'Nə isə səhv getdi';

  @override
  String get loadingMessagesError => 'Mesajlar yüklənərkən xəta baş verdi';

  @override
  String resultCountText(int count) => '$count nəticə';

  @override
  String get messageDeletedText => 'Bu mesaj silindi.';

  @override
  String get messageDeletedLabel => 'Mesaj silindi';

  @override
  String get systemMessageLabel => 'Sistem mesajı';

  @override
  String get editedMessageLabel => 'Redaktə edildi';

  @override
  String get messageReactionsLabel => 'Mesaj reaksiyaları';

  @override
  String get emptyChatMessagesText => 'Hələ söhbət yoxdur...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 cavab';
    return '$replyCount cavab';
  }

  @override
  String get connectedLabel => 'Qoşuldu';

  @override
  String get disconnectedLabel => 'Bağlantı kəsildi';

  @override
  String get reconnectingLabel => 'Yenidən qoşulur...';

  @override
  String get alsoSendAsDirectMessageLabel => 'Həmçinin Kanalda göndər';

  @override
  String get addACommentOrSendLabel => 'Şərh əlavə et və ya göndər';

  @override
  String get searchGifLabel => 'GIF axtar';

  @override
  String get writeAMessageLabel => 'Mesaj göndər';

  @override
  String get instantCommandsLabel => 'Ani əmrlər';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) => 'Fayl yükləmək üçün çox böyükdür. '
      'Fayl ölçüsü limiti $limitInMB MB-dır. '
      'Onu sıxmağa cəhd etdik, lakin bu kifayət etmədi.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'Fayl yükləmək üçün çox böyükdür. Fayl ölçüsü limiti $limitInMB MB-dır.';

  @override
  String fileTypeNotSupportedError(String? extension) {
    if (extension != null) {
      return "'.$extension' faylları yükləmə üçün dəstəklənmir.";
    }
    return 'Bu fayl növü yükləmə üçün dəstəklənmir.';
  }

  @override
  String get couldNotReadBytesFromFileError => 'Fayldan baytları oxumaq mümkün olmadı.';

  @override
  String get addAFileLabel => 'Fayl əlavə et';

  @override
  String get photoFromCameraLabel => 'Kameradan foto';

  @override
  String get uploadAFileLabel => 'Fayl yüklə';

  @override
  String get uploadAPhotoLabel => 'Foto yüklə';

  @override
  String get uploadAVideoLabel => 'Video yüklə';

  @override
  String get videoFromCameraLabel => 'Kameradan video';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Nə isə səhv getdi';

  @override
  String get addMoreFilesLabel => 'Daha çox əlavə et';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Zəhmət olmasa, foto və videolarınıza giriş icazəsi verin ki, onları dostlarınızla paylaşa biləsiniz.';

  @override
  String get allowGalleryAccessMessage => 'Qalereyaya giriş icazəsi ver';

  @override
  String get flagMessageLabel => 'Mesajı şikayət et';

  @override
  String get flagMessageQuestion => 'Bu mesajın surətini əlavə araşdırma üçün bir moderatora göndərmək istəyirsiniz?';

  @override
  String get flagLabel => 'Şikayət et';

  @override
  String get cancelLabel => 'Ləğv et';

  @override
  String get flagMessageSuccessfulLabel => 'Mesaj şikayət edildi';

  @override
  String get flagMessageSuccessfulText => 'Mesaj moderatora bildirildi.';

  @override
  String get deleteLabel => 'Sil';

  @override
  String get deleteMessageLabel => 'Mesajı sil';

  @override
  String get deleteMessageQuestion => 'Bu mesajı həmişəlik silmək istədiyinizə əminsiniz?';

  @override
  String get operationCouldNotBeCompletedText => 'Əməliyyat tamamlana bilmədi.';

  @override
  String get replyLabel => 'Cavab ver';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Söhbətdə sabitləməni ləğv et';
    return 'Söhbətdə sabitlə';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Mesajı silməyi yenidən cəhd et';
    return 'Mesajı sil';
  }

  @override
  String get copyMessageLabel => 'Mesajı kopyala';

  @override
  String get editMessageLabel => 'Mesajı redaktə et';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Redaktə edilmiş mesajı yenidən göndər';
    return 'Yenidən göndər';
  }

  @override
  String get photosLabel => 'Fotolar';

  @override
  String get photosAndVideosLabel => 'Foto və Videolar';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'bu gün';
    } else if (date == yesterday) {
      return 'dünən';
    } else {
      return '${Jiffy.parseFromDateTime(date).MMMd} tarixində';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return '${_getDay(date)} saat ${atTime.jm} göndərildi';
  }

  @override
  String get todayLabel => 'Bu gün';

  @override
  String get yesterdayLabel => 'Dünən';

  @override
  String get channelIsMutedText => 'Kanal səssizdir';

  @override
  String get noTitleText => 'Başlıq yoxdur';

  @override
  String get letsStartChattingLabel => 'Gəlin söhbətə başlayaq!';

  @override
  String get sendingFirstMessageLabel => 'Dostunuza ilk mesajınızı göndərməyə nə deyirsiniz?';

  @override
  String get startAChatLabel => 'Söhbətə başla';

  @override
  String get loadingChannelsError => 'Kanallar yüklənərkən xəta baş verdi';

  @override
  String get deleteConversationLabel => 'Söhbəti sil';

  @override
  String get deleteConversationQuestion => 'Bu söhbəti silmək istədiyinizə əminsiniz?';

  @override
  String get streamChatLabel => 'Söhbətlər';

  @override
  String get searchingForNetworkText => 'Şəbəkə axtarılır';

  @override
  String get offlineLabel => 'Oflayn...';

  @override
  String get tryAgainLabel => 'Yenidən cəhd et';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 üzv';
    return '$count üzv';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 onlayn';
    return '$count onlayn';
  }

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
  String get viewInfoLabel => 'Məlumata bax';

  @override
  String get leaveGroupLabel => 'Qrupdan çıx';

  @override
  String get leaveLabel => 'ÇIX';

  @override
  String get leaveConversationLabel => 'Söhbətdən çıx';

  @override
  String get leaveConversationQuestion => 'Bu söhbətdən çıxmaq istədiyinizə əminsiniz?';

  @override
  String get showInChatLabel => 'Söhbətdə göstər';

  @override
  String get saveImageLabel => 'Şəkli yadda saxla';

  @override
  String get saveVideoLabel => 'Videonu yadda saxla';

  @override
  String get uploadErrorLabel => 'YÜKLƏMƏ XƏTASI';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Qarışdır';

  @override
  String get sendLabel => 'Göndər';

  @override
  String get withText => 'ilə';

  @override
  String get inText => 'içində';

  @override
  String get youText => 'Siz';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} / $totalPages';

  @override
  String get fileText => 'Fayl';

  @override
  String get replyToMessageLabel => 'Mesaja cavab ver';

  @override
  String attachmentLimitExceedError(int limit) => 'Qoşma limiti aşıldı, limit: $limit';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'Yavaş rejim, $cooldownTimeOut s gözləyin…';

  @override
  String get commandUsernameLabel => '@istifadəçi_adı';

  @override
  String get downloadLabel => 'Endir';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'İstifadəçinin səsini aç';
    } else {
      return 'İstifadəçini səssiz et';
    }
  }

  @override
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'İstifadəçinin blokunu aç';
    return 'İstifadəçini blokla';
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Bu qrupun səsini açmaq istədiyinizə əminsiniz?';
    } else {
      return 'Bu qrupu səssiz etmək istədiyinizə əminsiniz?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Bu istifadəçinin səsini açmaq istədiyinizə əminsiniz?';
    } else {
      return 'Bu istifadəçini səssiz etmək istədiyinizə əminsiniz?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'SƏSİNİ AÇ';
    } else {
      return 'SƏSSİZ ET';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Qrupun səsini aç';
    } else {
      return 'Qrupu səssiz et';
    }
  }

  @override
  String get linkDisabledDetails => 'Bu söhbətdə link göndərmək qadağandır.';

  @override
  String get linkDisabledError => 'Linklər deaktivdir';

  @override
  String get viewLibrary => 'Kitabxanaya bax';

  @override
  String unreadMessagesSeparatorText() => 'Yeni mesajlar';

  @override
  String get enableFileAccessMessage =>
      'Zəhmət olmasa, fayllara giriş icazəsi verin ki, onları dostlarınızla paylaşa biləsiniz.';

  @override
  String get allowFileAccessMessage => 'Fayllara giriş icazəsi ver';

  @override
  String get markAsUnreadLabel => 'Oxunmamış işarələ';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount oxunmamış';
  }

  @override
  String get markUnreadError => 'Mesaj oxunmamış kimi işarələnərkən xəta baş verdi. Ən son 100 kanal '
      'mesajından köhnə mesajları oxunmamış kimi işarələmək mümkün deyil.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Yeni sorğu yarat';
    return 'Sorğu yarat';
  }

  @override
  String questionLabel({bool isPlural = false}) {
    if (isPlural) return 'Suallar';
    return 'Sual';
  }

  @override
  String get askAQuestionLabel => 'Sual ver';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && length < min) {
      return 'Sual ən azı $min simvol olmalıdır';
    }

    if (max != null && length > max) {
      return 'Sual ən çoxu $max simvol ola bilər';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Variantlar';
    return 'Variant';
  }

  @override
  String get pollOptionEmptyError => 'Variant boş ola bilməz';

  @override
  String get pollOptionDuplicateError => 'Bu variant artıq mövcuddur';

  @override
  String get addAnOptionLabel => 'Variant əlavə et';

  @override
  String get multipleAnswersLabel => 'Çoxlu cavab';

  @override
  String get maximumVotesPerPersonLabel => 'Hər şəxs üçün maksimum səs';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'Səs sayı ən azı $min olmalıdır';
    }

    if (max != null && votes > max) {
      return 'Səs sayı ən çoxu $max ola bilər';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Anonim sorğu';

  @override
  String get pollOptionsLabel => 'Sorğu variantları';

  @override
  String get suggestAnOptionLabel => 'Variant təklif et';

  @override
  String get enterANewOptionLabel => 'Yeni variant daxil et';

  @override
  String get addACommentLabel => 'Şərh əlavə et';

  @override
  String get pollCommentsLabel => 'Sorğu şərhləri';

  @override
  String get updateYourCommentLabel => 'Şərhinizi yeniləyin';

  @override
  String get enterYourCommentLabel => 'Şərhinizi daxil edin';

  @override
  String get endVoteConfirmationTitle => 'Bu sorğunu bitirək?';

  @override
  String get endVoteConfirmationMessage =>
      'Bu sorğunu indi bitirmək istəyirsiniz? Bundan sonra heç kim bu sorğuda səs verə bilməyəcək.';

  @override
  String get deletePollOptionLabel => 'Variantı sil';

  @override
  String get deletePollOptionQuestion => 'Bu variantı silmək istədiyinizə əminsiniz?';

  @override
  String get createLabel => 'Yarat';

  @override
  String get endLabel => 'Bitir';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Səsvermə bitdi',
      unique: () => 'Birini seç',
      limited: (count) => 'Maksimum $count seç',
      all: () => 'Bir və ya bir neçəsini seç',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Bütün variantlara bax';
    return 'Bütün $count variantı gör';
  }

  @override
  String get viewCommentsLabel => 'Şərhlərə bax';

  @override
  String get viewResultsLabel => 'Nəticələrə bax';

  @override
  String get endVoteLabel => 'Sorğunu bitir';

  @override
  String get pollResultsLabel => 'Sorğu nəticələri';

  @override
  String get pollVotesLabel => 'Səslər';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Bütün səsləri göstər';
    return 'Bütün $count səsi göstər';
  }

  @override
  String get viewAllLabel => 'Hamısına bax';

  @override
  String voteCountLabel({int? count}) => switch (count) {
        null || < 1 => '0 səs',
        1 => '1 səs',
        _ => '$count səs',
      };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
        null || < 1 => 'cəmi 0 səs',
        1 => 'cəmi 1 səs',
        _ => 'cəmi $count səs',
      };

  @override
  String get noPollVotesLabel => 'Hal-hazırda səs yoxdur';

  @override
  String get loadingPollVotesError => 'Səslər yüklənərkən xəta baş verdi';

  @override
  String get repliedToLabel => 'cavab verdi:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 yeni mövzu';
    return '$count yeni mövzu';
  }

  @override
  String get loadingLabel => 'Yüklənir...';

  @override
  String get slideToCancelLabel => 'Ləğv etmək üçün sürüşdür';

  @override
  String get holdToRecordLabel => 'Yazmaq üçün basılı saxla. Saxlamaq üçün burax.';

  @override
  String get sendAnywayLabel => 'Yenə də göndər';

  @override
  String get moderatedMessageBlockedText => 'Mesaj moderasiya qaydalarına görə bloklandı';

  @override
  String get moderationReviewModalTitle => 'Əminsiniz?';

  @override
  String get moderationReviewModalDescription =>
      '''Şərhinizin başqalarında necə təəssürat yarada biləcəyini düşünün və icma qaydalarımıza riayət etdiyinizə əmin olun.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Səs yazısı';

  @override
  String get audioAttachmentText => 'Audio';

  @override
  String get imageAttachmentText => 'Şəkil';

  @override
  String get videoAttachmentText => 'Video';

  @override
  String get fileAttachmentText => 'Fayl';

  @override
  String get linkAttachmentText => 'Link';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'Fayl' : '$count fayl';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Foto' : '$count foto';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Video' : '$count video';

  @override
  String get pollYouVotedText => 'Siz səs verdiniz';

  @override
  String pollSomeoneVotedText(String username) => '$username səs verdi';

  @override
  String get pollYouCreatedText => 'Siz yaratdınız';

  @override
  String pollSomeoneCreatedText(String username) => '$username yaratdı';

  @override
  String get draftLabel => 'Qaralama';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'Canlı məkan';
    return 'Məkan';
  }

  @override
  String get noConversationsYetText => 'Hələ söhbət yoxdur';

  @override
  String get replyToStartThreadText => 'Mövzu başlatmaq üçün mesaja cavab verin';

  @override
  String get sendMessageToStartConversationText => 'Söhbətə başlamaq üçün mesaj göndərin';

  @override
  String get savedForLaterLabel => 'Sonraya saxlanıldı';

  @override
  String get repliedToThreadAnnotationLabel => 'Mövzuya cavab verdi';

  @override
  String get alsoSentInChannelAnnotationLabel => 'Həmçinin kanalda göndərildi';

  @override
  String get viewLabel => 'Bax';

  @override
  String get reminderSetLabel => 'Xatırlatma quruldu';

  @override
  String reminderAtText(String time) => 'Bu gün saat $time';

  @override
  String get createPollPromptLabel => 'Sorğu yaradın və hamı səs versin!';

  @override
  String get takePhotoAndShareLabel => 'Foto çək və paylaş';

  @override
  String get takeVideoAndShareLabel => 'Video çək və paylaş';

  @override
  String get openCameraLabel => 'Kameranı aç';

  @override
  String get selectFilesToShareLabel => 'Paylaşmaq üçün fayllar seçin';

  @override
  String get openFilesLabel => 'Faylları aç';

  @override
  String get unsupportedAttachmentLabel => 'Dəstəklənməyən qoşma';

  @override
  String get confirmLabel => 'TƏSDİQLƏ';

  @override
  String get emptyReactionsText => 'Hələ reaksiya yoxdur';

  @override
  String get loadingReactionsError => 'Reaksiyalar yüklənərkən xəta baş verdi';

  @override
  String get tapToRemoveReactionLabel => 'Silmək üçün toxun';

  @override
  String reactionsCountText(int count) => count == 1 ? '1 reaksiya' : '$count reaksiya';

  @override
  String get justNowLabel => 'İndicə';

  @override
  String replyToUserLabel(String userName) => '$userName istifadəçisinə cavab ver';

  @override
  String get multipleAnswersDescription => 'Birdən çox variant seçin';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return '$min–$max arası variant seçin';
  }

  @override
  String get anonymousPollDescription => 'Kimin səs verdiyini gizlət';

  @override
  String get suggestAnOptionDescription => 'Başqalarının variant əlavə etməsinə icazə ver';

  @override
  String get addACommentDescription => 'Başqalarının şərh əlavə etməsinə icazə ver';
}
