part of 'stream_chat_localizations.dart';

/// The translations for Nepali (`ne`).
class StreamChatLocalizationsNe extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Nepali.
  const StreamChatLocalizationsNe({String localeName = 'ne'})
      : super(localeName: localeName);

  @override
  String get launchUrlError => 'यूआरएल सुरु गर्न सक्दैन';

  @override
  String get loadingUsersError => 'यूजरहरु लोड गर्न समस्या';

  @override
  String get noUsersLabel => 'हाल कुनै प्रयोगकर्ताहरु छैनन्';

  @override
  String get retryLabel => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get userLastOnlineText => 'पछिल्लो अनलाइन';

  @override
  String get userOnlineText => 'अनलाइन';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} टाइप गर्दैछ';
    }
    return '${first.name} र ${users.length - 1} टाइप जना गर्दैछन';
  }

  @override
  String get threadReplyLabel => 'थ्रेडमा उत्तर दिनू';

  @override
  String get onlyVisibleToYouText => 'मात्र तपाइँ देख्न सक्नुहुन्छ';

  @override
  String threadReplyCountText(int count) => '$count थ्रेड जवाफ';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      '$remaining/$total ... अपलोड गर्दै';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'तपाइँ द्वारा पिन गरीएको';
    return '${pinnedBy.name} द्वारा पिन गरीएको';
  }

  @override
  String get emptyMessagesText => 'हाल कुनै सन्देश छैन';

  @override
  String get genericErrorText => 'केहि समस्या भयो';

  @override
  String get loadingMessagesError => 'सन्देश लोड गर्ने समस्या';

  @override
  String resultCountText(int count) => '$count परिणाम';

  @override
  String get messageDeletedText => 'यो सन्देश हटाइएको छ।';

  @override
  String get messageDeletedLabel => 'सन्देश मेटाइयो';

  @override
  String get messageReactionsLabel => 'सन्देश प्रतिक्रियाहरु';

  @override
  String get emptyChatMessagesText => 'यहाँ अझै सम्म कुनै कुराकानी छैन ...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '१ जवाफ';
    return '$replyCount जवाफ हरु';
  }

  @override
  String get connectedLabel => 'कनेक्टेड';

  @override
  String get disconnectedLabel => 'डिस्कनेक्टेड';

  @override
  String get reconnectingLabel => 'पुन: जडान गर्दै ...';

  @override
  String get alsoSendAsDirectMessageLabel => 
  'प्रत्यक्ष सन्देश को रूप मा पठाउनुहोस्';

  @override
  String get addACommentOrSendLabel => 'एक टिप्पणी थप्नुहोस् वा पठाउनुहोस्';

  @override
  String get searchGifLabel => 'GIF भेट्टाउनुहोस्';

  @override
  String get writeAMessageLabel => 'एउटा सन्देश लेख्नुहोस्';

  @override
  String get instantCommandsLabel => 'तत्काल आदेश';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'फाइल अपलोड गर्न को लागी धेरै ठुलो छ। '
      'फाइल आकार सीमा $limitInMB MB छ। '
      'हामीले यसलाई कम्प्रेस गर्ने कोशिश गर्यौं, तर यो पर्याप्त थिएन।';

  @override
  String fileTooLargeError(double limitInMB) =>
      'फाइल अपलोड गर्न को लागी धेरै ठुलो छ। फाइल आकार सीमा $limitInMB MB छ। ';

  @override
  String emojiMatchingQueryText(String query) => '"$query" बाट मिल्ने इमोजीहरु';

  @override
  String get addAFileLabel => 'एउटा फाइल जोड्नुहोस्';

  @override
  String get photoFromCameraLabel => 'क्यामेरा बाट फोटो';

  @override
  String get uploadAFileLabel => 'एउटा फाइल अपलोड गर्नुहोस्';

  @override
  String get uploadAPhotoLabel => 'फोटो अपलोड गर्नुहोस्';

  @override
  String get uploadAVideoLabel => 'एउटा भिडियो अपलोड गर्नुहोस्';

  @override
  String get videoFromCameraLabel => 'क्यामेरा बाट भिडियो';

  @override
  String get okLabel => 'ठीक छ';

  @override
  String get somethingWentWrongError => 'लोड गर्ने मा समस्या';

  @override
  String get addMoreFilesLabel => 'थप फाइलहरु जोड्नुहोस्';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'कृपया तपाइँको फोटो र भिडियो को लागी पहुँच सक्षम गर्नुहोस्'
      '\nताकि तपाइँ उनीहरुलाई साथीहरु संग साझा गर्न सक्नुहुन्छ।';

  @override
  String get allowGalleryAccessMessage => 
  'तपाइँको ग्यालरीमा पहुँच गर्ने अनुमति दिनुहोस्';

  @override
  String get flagMessageLabel => 'सन्देश सन्देश फ्लाग गर्नुहोस';

  @override
  String get flagMessageQuestion => 
  'के तपाइँ थप अनुसन्धान को लागी यो सन्देशको '
      '\nमध्यस्थकर्तालाई एउटा प्रति पठाउन चाहनुहुन्छ?';

  @override
  String get flagLabel => 'फ्लैग';

  @override
  String get cancelLabel => 'रद्द गर्नुहोस्';

  @override
  String get flagMessageSuccessfulLabel => 'सन्देश फ्लैग भयो';

  @override
  String get flagMessageSuccessfulText =>
      'सन्देश एक मध्यस्थकर्तालाई रिपोर्ट गरिएको छ।';

  @override
  String get deleteLabel => 'हटाउनुहोस्';

  @override
  String get deleteMessageLabel => 'सन्देश मेटाउनुहोस्';

  @override
  // ignore: lines_longer_than_80_chars
  String get deleteMessageQuestion =>
'के तपाइँ पक्का हुनुहुन्छ कि तपाइँ यो सन्देश स्थायी रूप बाट मेटाउन चाहानुहुन्छ?';

  @override
  String get operationCouldNotBeCompletedText =>
      'कारबाही पूरा हुन सकेन।';

  @override
  String get replyLabel => 'जवाफ दिनुहोस';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'कुराकानी बाट अनपिन गर्नुहोस';
    return 'कुराकानी मा पिन गर्नुहोस';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'फेरि सन्देश मेटाउन कोसिस गर्नुहोस्';
    return 'सन्देश मेटाउनुहोस्';
  }

  @override
  String get copyMessageLabel => 'सन्देश प्रतिलिपि गर्नुहोस्';

  @override
  String get editMessageLabel => 'सन्देश सम्पादन गर्नुहोस्';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'सम्पादित सन्देश पुन: पठाउनुहोस्';
    return 'पुनः पठाउनुहोस्';
  }

  @override
  String get photosLabel => 'फोटोहरु';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'आज';
    } else if (date == yesterday) {
      return 'हिजो';
    } else {
      return '${Jiffy(date).MMMd} को';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '${_getDay(date)} ${Jiffy(time.toLocal()).format('HH:mm')} मा पठाइयो';

  @override
  String get todayLabel => 'आज';

  @override
  String get yesterdayLabel => 'हिजो';

  @override
  String get channelIsMutedText => 'च्यानल मौन गरिएको छ';

  @override
  String get noTitleText => 'कुनै शीर्षक छैन';

  @override
  String get letsStartChattingLabel => 'च्याट सुरु गरौं!';

  @override
  String get sendingFirstMessageLabel =>
      'तपाइँको पहिलो सन्देश पठाउनुहोस्';

  @override
  String get startAChatLabel => 'च्याट सुरु गर्नुहोस्';

  @override
  String get loadingChannelsError => 'च्यानल गर्न लोड समस्या';

  @override
  String get deleteConversationLabel => 'कुराकानी मेटाउनुहोस्';

  @override
  String get deleteConversationQuestion =>
      'के तपाइँ पक्का यो वार्तालाप मेटाउन चाहानुहुन्छ?';

  @override
  String get streamChatLabel => 'स्ट्रिम च्याट';

  @override
  String get searchingForNetworkText => 'नेटवर्क खोज्दै';

  @override
  String get offlineLabel => 'अफलाइन ...';

  @override
  String get tryAgainLabel => 'फेरि प्रयास गर्नुहोस्';

  @override
  String membersCountText(int count) {
    if (count == 1) return '१ सदस्य';
    return '$count सदस्यहरु';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '१ जना अनलाइन';
    return '$count जना अनलाइन';
  }

  @override
  String get viewInfoLabel => 'जानकारी हेर्नुहोस्';

  @override
  String get leaveGroupLabel => 'समुह छोडनुहोस';

  @override
  String get leaveLabel => 'छोडनुहोस';

  @override
  String get leaveConversationLabel => 'वार्तालाप छोडनुहोस';

  @override
  String get leaveConversationQuestion =>
      'के तपाइँ पक्का यो वार्तालाप छोड्न चाहानुहुन्छ?';

  @override
  String get showInChatLabel => 'च्याट मा देखाउनुहोस्';

  @override
  String get saveImageLabel => 'फोटो सेव गर्नुहोस्';

  @override
  String get saveVideoLabel => 'वीडियो सेव गर्नुहोस्';

  @override
  String get uploadErrorLabel => 'अपलोड गर्न समस्या';

  @override
  String get giphyLabel => 'गिफी';

  @override
  String get shuffleLabel => 'शफल गर्नुहोस्';

  @override
  String get sendLabel => 'पठाउनुहोस्';

  @override
  String get withText => 'विद'; //TODO: break?

  @override
  String get inText => 'इन'; //TODO: break?

  @override
  String get youText => 'तपाइँ';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} ऑफ़ $totalPages';

  @override
  String get fileText => 'फाइल';

  @override
  String get replyToMessageLabel => 'सन्देश को जवाफ';

  @override
  String attachmentLimitExceedError(int limit) => '''
संलग्नक सीमा: $limit संलग्नक भन्दा बढी थप्न सम्भव छैन
  ''';

  @override
  String get slowModeOnLabel => 'ढिलो मोड मा';
}
