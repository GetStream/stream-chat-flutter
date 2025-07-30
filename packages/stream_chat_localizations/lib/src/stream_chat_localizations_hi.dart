// ignore_for_file: lines_longer_than_80_chars

part of 'stream_chat_localizations.dart';

/// The translations for Hindi (`hi`).
class StreamChatLocalizationsHi extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Hindi.
  const StreamChatLocalizationsHi({super.localeName = 'hi'});

  @override
  String get launchUrlError => 'यूआरएल लॉन्च नहीं कर सकते';

  @override
  String get loadingUsersError => 'यूजर लोड करने में समस्या';

  @override
  String get noUsersLabel => 'वर्तमान में कोई यूजर नहीं हैं';

  @override
  String get noPhotoOrVideoLabel => 'कोई फोटो या वीडियो नहीं है।';

  @override
  String get retryLabel => 'पुन: प्रयास करे';

  @override
  String get userLastOnlineText => 'अंतिम ऑनलाइन';

  @override
  String get userOnlineText => 'ऑनलाइन';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} टाइप कर रहा है';
    }
    return '${first.name} और ${users.length - 1} और टाइप कर रहे हैं';
  }

  @override
  String get threadReplyLabel => 'थ्रेड जवाब';

  @override
  String get onlyVisibleToYouText => 'केवल आपको दिखाई दे रहा है';

  @override
  String threadReplyCountText(int count) => '$count थ्रेड जवाब';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'अपलोडिंग $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'आपके द्वारा पिन किया गया';
    return '${pinnedBy.name} द्वारा पिन किया गया';
  }

  @override
  String get sendMessagePermissionError => 'आपको संदेश भेजने की अनुमति नहीं है';

  @override
  String get emptyMessagesText => 'वर्तमान में कोई संदेश नहीं है';

  @override
  String get genericErrorText => 'कुछ समस्या हो गई';

  @override
  String get loadingMessagesError => 'संदेश लोड करने में समस्या';

  @override
  String resultCountText(int count) => '$count परिणाम';

  @override
  String get messageDeletedText => 'यह संदेश हटा दिया गया है।';

  @override
  String get messageDeletedLabel => 'संदेश हटा दिया गया';

  @override
  String get systemMessageLabel => 'सिस्टम संदेश';

  @override
  String get editedMessageLabel => 'संपादित';

  @override
  String get messageReactionsLabel => 'संदेश प्रतिक्रियाएं';

  @override
  String get emptyChatMessagesText => 'यहां अभी तक कोई चैट नहीं...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 जवाब';
    return '$replyCount जवाब';
  }

  @override
  String get connectedLabel => 'कनेक्टेड';

  @override
  String get disconnectedLabel => 'डिस्कनेक्टेड';

  @override
  String get reconnectingLabel => 'पुनः कनेक्टिंग...';

  @override
  String get alsoSendAsDirectMessageLabel => 'सीधे संदेश के रूप में भी भेजें';

  @override
  String get addACommentOrSendLabel => 'एक टिप्पणी जोड़ें या भेजें';

  @override
  String get searchGifLabel => 'जीआईएफ खोजें';

  @override
  String get writeAMessageLabel => 'एक सन्देश लिखिए';

  @override
  String get instantCommandsLabel => 'तत्काल आदेश';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'फ़ाइल अपलोड करने के लिए बहुत बड़ी है। '
      'फ़ाइल आकार सीमा $limitInMB MB है। '
      'हमने इसे कंप्रेस करने की कोशिश की, लेकिन यह काफी नहीं था।';

  @override
  String fileTooLargeError(double limitInMB) =>
      'फ़ाइल अपलोड करने के लिए बहुत बड़ी है। फ़ाइल आकार सीमा $limitInMB MB है।';

  @override
  String get couldNotReadBytesFromFileError => 'फ़ाइल से बाइट नहीं पढ़ सका.';

  @override
  String get addAFileLabel => 'एक फ़ाइल जोड़ें';

  @override
  String get photoFromCameraLabel => 'कैमरे से फोटो';

  @override
  String get uploadAFileLabel => 'एक फाइल अपलोड करें';

  @override
  String get uploadAPhotoLabel => 'एक फोटो अपलोड करो';

  @override
  String get uploadAVideoLabel => 'एक वीडियो अपलोड करें';

  @override
  String get videoFromCameraLabel => 'कैमरे से वीडियो';

  @override
  String get okLabel => 'ठीक';

  @override
  String get somethingWentWrongError => 'लोड करने में समस्या';

  @override
  String get addMoreFilesLabel => 'और फ़ाइलें जोड़ें';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'कृपया अपने फ़ोटो और वीडियो तक पहुंच सक्षम करे ताकि आप उन्हें मित्रों के साथ साझा कर सकें।';

  @override
  String get allowGalleryAccessMessage => 'अपनी गैलरी तक पहुंच की अनुमति दें';

  @override
  String get flagMessageLabel => 'फ्लैग संदेश';

  @override
  String get flagMessageQuestion =>
      'क्या आप आगे की जांच के लिए इस संदेश की एक प्रति मॉडरेटर को भेजना चाहते हैं?';

  @override
  String get flagLabel => 'फ्लैग';

  @override
  String get cancelLabel => 'रद्द करें';

  @override
  String get flagMessageSuccessfulLabel => 'संदेश फ्लैग हो गया';

  @override
  String get flagMessageSuccessfulText =>
      'संदेश की रिपोर्ट एक मॉडरेटर को कर दी गई है।';

  @override
  String get deleteLabel => 'हटाएँ';

  @override
  String get deleteMessageLabel => 'संदेश हटाएं';

  @override
  String get deleteMessageQuestion =>
      'क्या आप वाकई इस संदेश को स्थायी रूप से हटाना चाहते हैं?';

  @override
  String get operationCouldNotBeCompletedText =>
      'कार्रवाई पूरी नहीं की जा सकी.';

  @override
  String get replyLabel => 'जवाब दें';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'बातचीत से अनपिन करें';
    return 'बातचीत में पिन करें';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'संदेश हटाने का पुनः प्रयास करें';
    return 'संदेश को हटाएं';
  }

  @override
  String get copyMessageLabel => 'संदेश कॉपी करें';

  @override
  String get editMessageLabel => 'संदेश एडिट करें';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'एडिट संदेश फिर से भेजें';
    return 'पुन: भेजें';
  }

  @override
  String get photosLabel => 'फ़ोटोज';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'आज';
    } else if (date == yesterday) {
      return 'कल';
    } else {
      return '${Jiffy.parseFromDateTime(date).MMMd} को';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return '${_getDay(date)} ${atTime.jm} बजे भेजा गया';
  }

  @override
  String get todayLabel => 'आज';

  @override
  String get yesterdayLabel => 'कल';

  @override
  String get channelIsMutedText => 'चैनल म्यूट है';

  @override
  String get noTitleText => 'कोई शीर्षक नहीं';

  @override
  String get letsStartChattingLabel => 'चलो चैट करना शुरू करें!';

  @override
  String get sendingFirstMessageLabel =>
      'किसी मित्र को अपना पहला संदेश भेजने के बारे में क्या विचार है?';

  @override
  String get startAChatLabel => 'चैट शुरू करें';

  @override
  String get loadingChannelsError => 'चैनल लोड करने में समस्या';

  @override
  String get deleteConversationLabel => 'वार्तालाप हटाए';

  @override
  String get deleteConversationQuestion =>
      'क्या आप वाकई इस वार्तालाप को हटाना चाहते हैं?';

  @override
  String get streamChatLabel => 'स्ट्रीम चैट';

  @override
  String get searchingForNetworkText => 'नेटवर्क खोज रहे हैं';

  @override
  String get offlineLabel => 'ऑफलाइन...';

  @override
  String get tryAgainLabel => 'पुनः प्रयास करें';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 सदस्य';
    return '$count सदस्य';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 ऑनलाइन';
    return '$count ऑनलाइन';
  }

  @override
  String get viewInfoLabel => 'जानकारी देखें';

  @override
  String get leaveGroupLabel => 'समूह छोड़े';

  @override
  String get leaveLabel => 'छोड़े';

  @override
  String get leaveConversationLabel => 'वार्तालाप छोड़े';

  @override
  String get leaveConversationQuestion =>
      'क्या आप वाकई इस बातचीत को छोड़ना चाहते हैं?';

  @override
  String get showInChatLabel => 'चैट में दिखाएं';

  @override
  String get saveImageLabel => 'चित्र को सेव करें';

  @override
  String get saveVideoLabel => 'वीडियो को सेव करे';

  @override
  String get uploadErrorLabel => 'अपलोड समस्या';

  @override
  String get giphyLabel => 'जिफ़ी';

  @override
  String get shuffleLabel => 'बदलें';

  @override
  String get sendLabel => 'भेजें';

  @override
  String get withText => 'विद';

  @override
  String get inText => 'इन';

  @override
  String get youText => 'आप';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} ऑफ़ $totalPages';

  @override
  String get fileText => 'फ़ाइल';

  @override
  String get replyToMessageLabel => 'संदेश का जवाब';

  @override
  String attachmentLimitExceedError(int limit) => '''
अटैचमेंट लिमिट: $limit अटैचमेंट से अधिक जोड़ना संभव नहीं है
  ''';

  @override
  String get viewLibrary => 'पुस्तकालय देखिये';

  @override
  String get slowModeOnLabel => 'स्लो मोड चालू';

  @override
  String get downloadLabel => 'डाउनलोड';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'उपयोगकर्ता को अनम्यूट करें';
    } else {
      return 'उपयोगकर्ता को म्यूट करें';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'क्या आप वाकई इस समूह को अनम्यूट करना चाहते हैं?';
    } else {
      return 'क्या आप वाकई इस समूह को म्यूट करना चाहते हैं?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'क्या आप वाकई इस उपयोगकर्ता को अनम्यूट करना चाहते हैं?';
    } else {
      return 'क्या आप वाकई इस उपयोगकर्ता को म्यूट करना चाहते हैं?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'अनम्यूट';
    } else {
      return 'मूक';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'समूह अनम्यूट करें';
    } else {
      return 'मूक समूह';
    }
  }

  @override
  String get linkDisabledDetails =>
      'इस बातचीत में लिंक भेजने की अनुमति नहीं है.';

  @override
  String get linkDisabledError => 'लिंक भेजना प्रतिबंधित';

  @override
  String unreadMessagesSeparatorText() => 'नए संदेश।';

  @override
  String get enableFileAccessMessage =>
      'कृपया फ़ाइलों तक पहुंच सक्षम करें ताकि आप उन्हें मित्रों के साथ साझा कर सकें।';

  @override
  String get allowFileAccessMessage => 'फाइलों तक पहुंच की अनुमति दें';

  @override
  String get markAsUnreadLabel => 'अपठित चिह्नित करें';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount अपठित';
  }

  @override
  String get markUnreadError =>
      'संदेश को अपठित मार्क करने में त्रुटि। सबसे नए 100 चैनल संदेश से पहले के'
      ' सभी अपठित संदेशों को अपठित मार्क नहीं किया जा सकता है।';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'एक नया पोल बनाएँ';
    return 'पोल बनाएँ';
  }

  @override
  String get questionsLabel => 'प्रश्न';

  @override
  String get askAQuestionLabel => 'प्रश्न पूछें';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'प्रश्न कम से कम $min अक्षर का होना चाहिए';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'प्रश्न अधिकतम $max अक्षर का हो सकता है';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) => 'विकल्प';

  @override
  String get pollOptionEmptyError => 'विकल्प खाली नहीं हो सकता';

  @override
  String get pollOptionDuplicateError => 'यह पहले से ही एक विकल्प है';

  @override
  String get addAnOptionLabel => 'विकल्प जोड़ें';

  @override
  String get multipleAnswersLabel => 'एक से अधिक उत्तर';

  @override
  String get maximumVotesPerPersonLabel => 'प्रति व्यक्ति अधिकतम वोट';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'वोटों की गिनती कम से कम $min होनी चाहिए';
    }

    if (max != null && votes > max) {
      return 'वोटों की गिनती ज्यादा से ज्यादा $max हो सकती है';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'अज्ञात पोल';

  @override
  String get suggestAnOptionLabel => 'विकल्प सुझाएं';

  @override
  String get addACommentLabel => 'कमेंट जोड़ें';

  @override
  String get createLabel => 'क्रिएट करें';

  @override
  String get endVoteLabel => 'वोट समाप्त करें';

  @override
  String get enterANewOptionLabel => 'एक नया विकल्प दर्ज करें';

  @override
  String get enterYourCommentLabel => 'अपनी टिप्पणी दर्ज करें';

  @override
  String get endVoteConfirmationText =>
      'क्या आप वाकई मतदान समाप्त करना चाहते हैं?';

  @override
  String get endLabel => 'समाप्त';

  @override
  String get loadingPollVotesError => 'पोल वोट लोड करने में त्रुटि';

  @override
  String get noPollVotesLabel => 'कोई पोल वोट नहीं';

  @override
  String get pollCommentsLabel => 'पोल टिप्पणियाँ';

  @override
  String get pollOptionsLabel => 'पोल विकल्प';

  @override
  String get pollResultsLabel => 'पोल परिणाम';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'मतदान समाप्त',
      unique: () => 'एक चुनें',
      limited: (count) => '$count तक चुनें',
      all: () => 'एक या अधिक चुनें',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count != null) {
      return 'सभी $count विकल्प देखें';
    }
    return 'सभी विकल्प देखें';
  }

  @override
  String showAllVotesLabel({int? count}) {
    if (count != null) {
      return 'सभी $count वोट दिखाएं';
    }
    return 'सभी वोट दिखाएं';
  }

  @override
  String get updateYourCommentLabel => 'अपनी टिप्पणी अपडेट करें';

  @override
  String get viewCommentsLabel => 'टिप्पणियाँ देखें';

  @override
  String get viewResultsLabel => 'परिणाम देखें';

  @override
  String voteCountLabel({int? count}) {
    if (count != null) {
      return '$count वोट';
    }
    return 'वोट';
  }

  @override
  String get repliedToLabel => 'जवाब दिया:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 नया थ्रेड';
    return '$count नए थ्रेड्स';
  }

  @override
  String get slideToCancelLabel => 'रद्द करने के लिए स्लाइड करें';

  @override
  String get holdToRecordLabel =>
      'रिकॉर्ड करने के लिए दबाए रखें, भेजने के लिए छोड़ें';

  @override
  String get sendAnywayLabel => 'फिर भी भेजें';

  @override
  String get moderatedMessageBlockedText =>
      'मॉडरेशन नीतियों द्वारा संदेश अवरुद्ध किया गया';

  @override
  String get moderationReviewModalTitle => 'क्या आप निश्चित हैं?';

  @override
  String get moderationReviewModalDescription =>
      '''इस बात पर विचार करें कि आपकी टिप्पणी से दूसरों को कैसा महसूस हो सकता है और सुनिश्चित करें कि आप हमारे समुदाय दिशानिर्देशों का पालन करें।''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'ध्वनि रिकॉर्डिंग';

  @override
  String get audioAttachmentText => 'ऑडियो';

  @override
  String get imageAttachmentText => 'फोटो';

  @override
  String get videoAttachmentText => 'वीडियो';

  @override
  String get pollYouVotedText => 'आपने वोट दिया';

  @override
  String pollSomeoneVotedText(String username) => '$username ने वोट दिया';

  @override
  String get pollYouCreatedText => 'आपने बनाया';

  @override
  String pollSomeoneCreatedText(String username) => '$username ने बनाया';

  @override
  String get draftLabel => 'ड्राफ्ट';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return '📍 लाइव लोकेशन';
    return '📍 लोकेशन';
  }
}
