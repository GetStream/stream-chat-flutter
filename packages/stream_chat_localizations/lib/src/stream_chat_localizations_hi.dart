part of 'stream_chat_localizations.dart';

/// The translations for Hindi (`hi`).
class StreamChatLocalizationsHi extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Hindi.
  const StreamChatLocalizationsHi({String localeName = 'hi'})
      : super(localeName: localeName);

  @override
  String get launchUrlError => 'यूआरएल लॉन्च नहीं कर सकते';

  @override
  String get loadingUsersError => 'यूजर लोड करने में समस्या';

  @override
  String get noUsersLabel => 'वर्तमान में कोई यूजर नहीं हैं';

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
  String get messageDeletedLabel => 'संदेश हटाये';

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
  String emojiMatchingQueryText(String query) => '"$query" से मिलते हुए इमोजी';

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
      'कृपया अपने फ़ोटो और वीडियो तक पहुंच सक्षम करें'
      '\nताकि आप उन्हें मित्रों के साथ साझा कर सकें।';

  @override
  String get allowGalleryAccessMessage => 'अपनी गैलरी तक पहुंच की अनुमति दें';

  @override
  String get flagMessageLabel => 'फ्लैग संदेश';

  @override
  String get flagMessageQuestion => 'क्या आप आगे की जांच के लिए इस संदेश की'
      '\nएक प्रति मॉडरेटर को भेजना चाहते हैं?';

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
      'क्या आप वाकई इस संदेश को स्थायी रूप से\nहटाना चाहते हैं?';

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
      return '${Jiffy(date).MMMd} को';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '${_getDay(date)} ${Jiffy(time.toLocal()).format('HH:mm')} बजे भेजा गया';

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
  String get withText => 'विद'; //TODO: break?

  @override
  String get inText => 'इन'; //TODO: break?

  @override
  String get youText => 'आप';

  @override
  String galleryPaginationText(
          {required int currentPage, required int totalPages}) =>
      '${currentPage + 1} ऑफ़ $totalPages';

  @override
  String get fileText => 'फ़ाइल';

  @override
  String get replyToMessageLabel => 'संदेश का जवाब';

  @override
  String attachmentLimitExceedError(int limit) {
    // TODO: implement attachmentLimitExceedError
    throw UnimplementedError();
  }

  @override
  String get slowModeOnLabel => 'स्लो मोड चालू';
}
