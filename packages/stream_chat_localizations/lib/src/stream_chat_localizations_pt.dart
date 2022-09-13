part of 'stream_chat_localizations.dart';

/// The translations for Portuguese (`pt`).
class StreamChatLocalizationsPt extends GlobalStreamChatLocalizations {
  /// Create an instance of the translation bundle for Portuguese.
  const StreamChatLocalizationsPt({super.localeName = 'pt'});

  @override
  String get launchUrlError => 'O URL não pôde ser aberto';

  @override
  String get loadingUsersError => 'Erro de carregamento do usuário';

  @override
  String get noUsersLabel => 'Nenhum usuário atualmente';

  @override
  String get retryLabel => 'Tente novamente';

  @override
  String get userLastOnlineText => 'Última vez on-line';

  @override
  String get userOnlineText => 'Online';

  @override
  String userTypingText(Iterable<User> users) {
    if (users.isEmpty) return '';
    final first = users.first;
    if (users.length == 1) {
      return '${first.name} está digitando';
    }
    return '${first.name} e ${users.length - 1} estão digitando';
  }

  @override
  String get threadReplyLabel => 'Responder na conversa';

  @override
  String get onlyVisibleToYouText => 'Visível apenas para você';

  @override
  String threadReplyCountText(int count) => '$count respostas na conversa';

  @override
  String attachmentsUploadProgressText({
    required int remaining,
    required int total,
  }) =>
      'Tranferência em andamento $remaining/$total ...';

  @override
  String pinnedByUserText({
    required User pinnedBy,
    required User currentUser,
  }) {
    final pinnedByCurrentUser = currentUser.id == pinnedBy.id;
    if (pinnedByCurrentUser) return 'Definido por você';
    return 'Definido por ${pinnedBy.name}';
  }

  @override
  String get emptyMessagesText => 'Não há mensagens';

  @override
  String get genericErrorText => 'Ocorreu um problema';

  @override
  String get loadingMessagesError => 'Ocorreu um problema ao carregar mensagem';

  @override
  String resultCountText(int count) => '$count resultados';

  @override
  String get messageDeletedText => 'Esta mensagem foi excluída.';

  @override
  String get messageDeletedLabel => 'Mensagem excluída';

  @override
  String get messageReactionsLabel => 'Reações às mensagens';

  @override
  String get emptyChatMessagesText => 'Ainda não há mensagens aqui...';

  @override
  String threadSeparatorText(int replyCount) {
    if (replyCount == 1) return '1 resposta';
    return '$replyCount respostas';
  }

  @override
  String get connectedLabel => 'Conectado';

  @override
  String get disconnectedLabel => 'Desconectado';

  @override
  String get reconnectingLabel => 'Reconectando...';

  @override
  String get alsoSendAsDirectMessageLabel =>
      'Enviar também como mensagem direta';

  @override
  String get addACommentOrSendLabel => 'Adicionar um comnetário ou enviar';

  @override
  String get searchGifLabel => 'Pesquisar GIFs';

  @override
  String get writeAMessageLabel => 'Escrever uma mensagem';

  @override
  String get instantCommandsLabel => 'Comandos instantâneos';

  @override
  String fileTooLargeAfterCompressionError(double limitInMB) =>
      'O arquivo é muito grande para carregamento. '
      'O tamanho máximo do arquivo é de $limitInMB MB. '
      'Tentamos comprimi-lo, mas não foi suficiente.';

  @override
  String fileTooLargeError(double limitInMB) =>
      'O arquivo é muito grande para carregamento. '
      'O tamanho máximo dos arquivos é de $limitInMB MB.';

  @override
  String get couldNotReadBytesFromFileError =>
      'Não foi possível ler os bytes do arquivo.';

  @override
  String get addAFileLabel => 'Adicionar um arquivo';

  @override
  String get photoFromCameraLabel => 'Foto da câmera';

  @override
  String get uploadAFileLabel => 'Transferir um arquivo';

  @override
  String get uploadAPhotoLabel => 'Carregar uma foto';

  @override
  String get uploadAVideoLabel => 'Carregar um vídeo';

  @override
  String get videoFromCameraLabel => 'Vídeo da câmera';

  @override
  String get okLabel => 'OK';

  @override
  String get somethingWentWrongError => 'Algo deu errado';

  @override
  String get addMoreFilesLabel => 'Adicionar mais arquivos';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Por favor, permita o acesso a suas fotos'
      '\ne vídeos para que possa compartilhar com sua rede.';

  @override
  String get allowGalleryAccessMessage => 'Permitir acesso à sua galeria';

  @override
  String get flagMessageLabel => 'Denunciar mensagem';

  @override
  String get flagMessageQuestion => 'Gostaria de enviar esta mensagem ao'
      '\nmoderador para maior investigação?';

  @override
  String get flagLabel => 'DENUNCIAR';

  @override
  String get cancelLabel => 'CANCELAR';

  @override
  String get flagMessageSuccessfulLabel => 'Mensagem denunciada';

  @override
  String get flagMessageSuccessfulText =>
      'Esta mensagem foi enviada a um moderador.';

  @override
  String get deleteLabel => 'APAGAR';

  @override
  String get deleteMessageLabel => 'Apagar mensagem';

  @override
  String get deleteMessageQuestion =>
      'Você tem certeza que deseja apagar essa\nmensagem permanentemente?';

  @override
  String get operationCouldNotBeCompletedText =>
      'A operação não pode ser completada.';

  @override
  String get replyLabel => 'Resposta';

  @override
  String togglePinUnpinText({required bool pinned}) {
    if (pinned) return 'Desafixar na conversa';
    return 'Fixar na conversa';
  }

  @override
  String toggleDeleteRetryDeleteMessageText({required bool isDeleteFailed}) {
    if (isDeleteFailed) return 'Repetir apagar mensagem';
    return 'Apagar mensagem';
  }

  @override
  String get copyMessageLabel => 'Copiar mensagem';

  @override
  String get editMessageLabel => 'Editar mensagem';

  @override
  String toggleResendOrResendEditedMessage({required bool isUpdateFailed}) {
    if (isUpdateFailed) return 'Reenviar mensagem alterada';
    return 'Reenviar';
  }

  @override
  String get photosLabel => 'Fotos';

  String _getDay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Hoje';
    } else if (date == yesterday) {
      return 'Ontem';
    } else {
      return 'o ${Jiffy(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) =>
      '''Enviado ${_getDay(date)} às ${Jiffy(time.toLocal()).format('HH:mm')}''';

  @override
  String get todayLabel => 'Hoje';

  @override
  String get yesterdayLabel => 'Ontem';

  @override
  String get channelIsMutedText => 'O canal está silenciado';

  @override
  String get noTitleText => 'Sem título';

  @override
  String get letsStartChattingLabel => 'Vamos começar a conversar!';

  @override
  String get sendingFirstMessageLabel =>
      'Que tal enviar sua primeira mensagem a um amigo?';

  @override
  String get startAChatLabel => 'Iniciar uma conversa';

  @override
  String get loadingChannelsError => 'Erro ao carregar os canais';

  @override
  String get deleteConversationLabel => 'Apagar a conversa';

  @override
  String get deleteConversationQuestion =>
      'Tem certeza que deseja apagar essa conversa?';

  @override
  String get streamChatLabel => 'Stream Chat';

  @override
  String get searchingForNetworkText => 'Pesquisando rede';

  @override
  String get offlineLabel => 'Sem conexão...';

  @override
  String get tryAgainLabel => 'Tente novamente';

  @override
  String membersCountText(int count) {
    if (count == 1) return '1 membro';
    return '$count membros';
  }

  @override
  String watchersCountText(int count) {
    if (count == 1) return '1 online';
    return '$count online';
  }

  @override
  String get viewInfoLabel => 'Ver informação';

  @override
  String get leaveGroupLabel => 'Sair do grupo';

  @override
  String get leaveLabel => 'SAIR';

  @override
  String get leaveConversationLabel => 'Sair da conversa';

  @override
  String get leaveConversationQuestion =>
      'Tem certeza que deseja sair dessa conversa?';

  @override
  String get showInChatLabel => 'Mostrar no chat';

  @override
  String get saveImageLabel => 'Salvar imagem';

  @override
  String get saveVideoLabel => 'Salvar vídeo';

  @override
  String get uploadErrorLabel => 'ERRO DE TRANSFERÊNCIA';

  @override
  String get giphyLabel => 'Giphy';

  @override
  String get shuffleLabel => 'Misturar';

  @override
  String get sendLabel => 'Enviar';

  @override
  String get withText => 'com';

  @override
  String get inText => 'em';

  @override
  String get youText => 'Você';

  @override
  String galleryPaginationText({
    required int currentPage,
    required int totalPages,
  }) =>
      '${currentPage + 1} de $totalPages';

  @override
  String get fileText => 'Arquivo';

  @override
  String get replyToMessageLabel => 'Responder à mensagem';

  @override
  String attachmentLimitExceedError(int limit) => '''
Não é possível adicionar mais de $limit arquivos de uma vez
  ''';

  @override
  String get slowModeOnLabel => 'Modo lento ativado';

  @override
  String get downloadLabel => 'Download';

  @override
  String toggleMuteUnmuteUserText({required bool isMuted}) {
    if (isMuted) {
      return 'Ativar o som do usuário';
    } else {
      return 'Silenciar usuário';
    }
  }

  @override
  String toggleMuteUnmuteGroupQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Tem certeza de que deseja ativar o som deste grupo?';
    } else {
      return 'Tem certeza de que deseja silenciar este grupo?';
    }
  }

  @override
  String toggleMuteUnmuteUserQuestion({required bool isMuted}) {
    if (isMuted) {
      return 'Tem certeza de que deseja ativar o som deste usuário?';
    } else {
      return 'Tem certeza de que deseja silenciar este usuário?';
    }
  }

  @override
  String toggleMuteUnmuteAction({required bool isMuted}) {
    if (isMuted) {
      return 'ATIVAR MUDO';
    } else {
      return 'MUDO';
    }
  }

  @override
  String toggleMuteUnmuteGroupText({required bool isMuted}) {
    if (isMuted) {
      return 'Reativar o som do grupo';
    } else {
      return 'Silenciar Grupo';
    }
  }

  @override
  String get linkDisabledDetails =>
      'O envio de links não é permitido nesta conversa.';

  @override
  String get linkDisabledError => 'Os links estão desativados';

  @override
  String get sendMessagePermissionError =>
      'Você não tem permissão para enviar mensagens';

  @override
  String get viewLibrary => 'Ver biblioteca';

  @override
  String unreadMessagesSeparatorText(int unreadCount) {
    if (unreadCount == 1) {
      return '1 mensagem não lida';
    }
    return '$unreadCount mensagens não lidas';
  }

  @override
  String get enableFileAccessMessage =>
      'Ative o acesso aos arquivos' '\npara poder compartilhá-los com amigos.';

  @override
  String get allowFileAccessMessage => 'Permitir acesso aos arquivos';
}
