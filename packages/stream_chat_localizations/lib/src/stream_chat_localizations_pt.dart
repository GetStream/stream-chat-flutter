// ignore_for_file: lines_longer_than_80_chars

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
  String get noPhotoOrVideoLabel => 'Não há fotos ou vídeos';

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
  String get threadLabel => 'Conversa';

  @override
  String get onlyVisibleToYouText => 'Visível apenas para você';

  @override
  String threadReplyCountText(int count) => '$count respostas na conversa';

  @override
  String attachmentsUploadProgressText({
    required int completed,
    required int total,
  }) => 'Enviados $completed de $total ...';

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
  String get emptyMessagesText => 'Ainda não há mensagens';

  @override
  String get genericErrorText => 'Ocorreu um problema';

  @override
  String get loadingMessagesError => 'Ocorreu um problema ao carregar a mensagem';

  @override
  String resultCountText(int count) => '$count resultados';

  @override
  String get messageDeletedText => 'Esta mensagem foi excluída.';

  @override
  String get messageDeletedLabel => 'Mensagem excluída';

  @override
  String get systemMessageLabel => 'Mensagem do sistema';

  @override
  String get editedMessageLabel => 'Editada';

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
  String get alsoSendAsDirectMessageLabel => 'Enviar também como mensagem direta';

  @override
  String get addACommentOrSendLabel => 'Adicionar um comnetário ou enviar';

  @override
  String get searchGifLabel => 'Pesquisar GIFs';

  @override
  String get writeAMessageLabel => 'Enviar uma mensagem';

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
  String fileTypeNotSupportedError(String? extension) => extension != null
      ? "'.$extension' files are not supported for upload."
      : 'This file type is not supported for upload.';

  @override
  String get couldNotReadBytesFromFileError => 'Não foi possível ler os bytes do arquivo.';

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
  String get addMoreFilesLabel => 'Adicionar mais';

  @override
  String get enablePhotoAndVideoAccessMessage =>
      'Por favor, permita o acesso às suas fotos e vídeos para que possa compartilhar com sua rede.';

  @override
  String get allowGalleryAccessMessage => 'Permitir acesso à sua galeria';

  @override
  String get flagMessageLabel => 'Denunciar mensagem';

  @override
  String get flagMessageQuestion => 'Gostaria de enviar esta mensagem ao moderador para maior investigação?';

  @override
  String get flagLabel => 'Denunciar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get flagMessageSuccessfulLabel => 'Mensagem denunciada';

  @override
  String get flagMessageSuccessfulText => 'Esta mensagem foi enviada a um moderador.';

  @override
  String get deleteLabel => 'Apagar';

  @override
  String get deleteMessageLabel => 'Apagar mensagem';

  @override
  String get deleteMessageQuestion => 'Você tem certeza que deseja apagar essa mensagem permanentemente?';

  @override
  String get operationCouldNotBeCompletedText => 'A operação não pode ser completada.';

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

  @override
  String get photosAndVideosLabel => 'Fotos e vídeos';

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
      return 'o ${Jiffy.parseFromDateTime(date).MMMd}';
    }
  }

  @override
  String sentAtText({required DateTime date, required DateTime time}) {
    final atTime = Jiffy.parseFromDateTime(time.toLocal());
    return 'Enviado ${_getDay(date)} às ${atTime.jm}';
  }

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
  String get sendingFirstMessageLabel => 'Que tal enviar sua primeira mensagem a um amigo?';

  @override
  String get startAChatLabel => 'Iniciar uma conversa';

  @override
  String get loadingChannelsError => 'Erro ao carregar os canais';

  @override
  String get deleteConversationLabel => 'Apagar a conversa';

  @override
  String get deleteConversationQuestion => 'Tem certeza que deseja apagar essa conversa?';

  @override
  String get streamChatLabel => 'Conversas';

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
  String membersCountWithOnlineText({
    required int memberCount,
    required int onlineCount,
  }) {
    final members = membersCountText(memberCount);
    if (onlineCount <= 0) return members;
    return '$members, ${watchersCountText(onlineCount)}';
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
  String get leaveConversationQuestion => 'Tem certeza que deseja sair dessa conversa?';

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
  }) => '${currentPage + 1} de $totalPages';

  @override
  String get fileText => 'Arquivo';

  @override
  String get replyToMessageLabel => 'Responder à mensagem';

  @override
  String attachmentLimitExceedError(int limit) =>
      '''
Não é possível adicionar mais de $limit arquivos de uma vez
  ''';

  @override
  String slowModeOnLabel(int cooldownTimeOut) => 'Modo lento, aguarde ${cooldownTimeOut}s\u2026';

  @override
  String get commandUsernameLabel => '@username';

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
  String toggleBlockUnblockUserText({required bool isBlocked}) {
    if (isBlocked) return 'Desbloquear usuário';
    return 'Bloquear usuário';
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
  String get linkDisabledDetails => 'O envio de links não é permitido nesta conversa.';

  @override
  String get linkDisabledError => 'Os links estão desativados';

  @override
  String get sendMessagePermissionError => 'Você não tem permissão para enviar mensagens';

  @override
  String get viewLibrary => 'Ver biblioteca';

  @override
  String unreadMessagesSeparatorText() => 'Novas mensagens';

  @override
  String get enableFileAccessMessage => 'Ative o acesso aos arquivos para poder compartilhá-los com amigos.';

  @override
  String get allowFileAccessMessage => 'Permitir acesso aos arquivos';

  @override
  String get markAsUnreadLabel => 'Marcar como não lida';

  @override
  String unreadCountIndicatorLabel({required int unreadCount}) {
    return '$unreadCount não lidas';
  }

  @override
  String get markUnreadError =>
      'Erro ao marcar a mensagem como não lida. Não é possível marcar mensagens'
      ' não lidas mais antigas do que as 100 mensagens mais recentes do canal.';

  @override
  String createPollLabel({bool isNew = false}) {
    if (isNew) return 'Criar uma nova sondagem';
    return 'Criar sondagem';
  }

  @override
  String questionLabel({bool isPlural = false}) {
    if (isPlural) return 'Perguntas';
    return 'Pergunta';
  }

  @override
  String get askAQuestionLabel => 'Fazer uma pergunta';

  @override
  String? pollQuestionValidationError(int length, Range<int> range) {
    final (:min, :max) = range;

    // Check if the question is too short.
    if (min != null && length < min) {
      return 'A pergunta deve ter pelo menos $min caracteres';
    }

    // Check if the question is too long.
    if (max != null && length > max) {
      return 'A pergunta deve ter, no máximo, $max caracteres';
    }

    return null;
  }

  @override
  String optionLabel({bool isPlural = false}) {
    if (isPlural) return 'Opções';
    return 'Opção';
  }

  @override
  String get pollOptionEmptyError => 'A opção não pode estar vazia';

  @override
  String get pollOptionDuplicateError => 'Esta já é uma opção';

  @override
  String get addAnOptionLabel => 'Adicionar uma opção';

  @override
  String get multipleAnswersLabel => 'Respostas múltiplas';

  @override
  String get maximumVotesPerPersonLabel => 'Máximo de votos por pessoa';

  @override
  String? maxVotesPerPersonValidationError(int votes, Range<int> range) {
    final (:min, :max) = range;

    if (min != null && votes < min) {
      return 'A contagem dos votos deve ser de, pelo menos, $min';
    }

    if (max != null && votes > max) {
      return 'A contagem dos votos deve ser, no máximo, $max';
    }

    return null;
  }

  @override
  String get anonymousPollLabel => 'Votação anônima';

  @override
  String get pollOptionsLabel => 'Opções de votação';

  @override
  String get suggestAnOptionLabel => 'Sugerir uma opção';

  @override
  String get enterANewOptionLabel => 'Inserir uma nova opção';

  @override
  String get addACommentLabel => 'Adicionar um comentário';

  @override
  String get pollCommentsLabel => 'Comentários da votação';

  @override
  String get updateYourCommentLabel => 'Atualizar seu comentário';

  @override
  String get enterYourCommentLabel => 'Inserir seu comentário';

  @override
  String get endVoteConfirmationTitle => 'Tem certeza de que deseja encerrar a votação?';

  @override
  String get endVoteConfirmationMessage =>
      'Deseja encerrar esta enquete agora? Ninguém mais poderá votar nesta enquete.';

  @override
  String get deletePollOptionLabel => 'Excluir opção';

  @override
  String get deletePollOptionQuestion => 'Tem certeza de que deseja excluir esta opção?';

  @override
  String get createLabel => 'Criar';

  @override
  String get endLabel => 'Encerrar';

  @override
  String pollVotingModeLabel(PollVotingMode votingMode) {
    return votingMode.when(
      disabled: () => 'Votação encerrada',
      unique: () => 'Selecionar um',
      limited: (count) => 'Selecionar até $count',
      all: () => 'Selecionar um ou mais',
    );
  }

  @override
  String seeAllOptionsLabel({int? count}) {
    if (count == null) return 'Ver todas as opções';
    return 'Ver todas as $count opções';
  }

  @override
  String get viewCommentsLabel => 'Ver comentários';

  @override
  String get viewResultsLabel => 'Ver resultados';

  @override
  String get endVoteLabel => 'Encerrar votação';

  @override
  String get pollResultsLabel => 'Resultados da votação';

  @override
  String get pollVotesLabel => 'Votos';

  @override
  String showAllVotesLabel({int? count}) {
    if (count == null) return 'Mostrar todos os votos';
    return 'Mostrar todos os $count votos';
  }

  @override
  String get viewAllLabel => 'Ver tudo';

  @override
  String voteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 votos',
    1 => '1 voto',
    _ => '$count votos',
  };

  @override
  String totalVoteCountLabel({int? count}) => switch (count) {
    null || < 1 => '0 votos no total',
    1 => '1 voto no total',
    _ => '$count votos no total',
  };

  @override
  String get noPollVotesLabel => 'Não há votos no momento';

  @override
  String get loadingPollVotesError => 'Erro ao carregar os votos';

  @override
  String get repliedToLabel => 'respondeu a:';

  @override
  String newThreadsLabel({required int count}) {
    if (count == 1) return '1 novo tópico';
    return '$count novos tópicos';
  }

  @override
  String get loadingLabel => 'Carregando...';

  @override
  String get slideToCancelLabel => 'Deslize para cancelar';

  @override
  String get holdToRecordLabel => 'Mantenha pressionado para gravar, solte para enviar';

  @override
  String get sendAnywayLabel => 'Enviar mesmo assim';

  @override
  String get moderatedMessageBlockedText => 'Mensagem bloqueada pelas políticas de moderação';

  @override
  String get moderationReviewModalTitle => 'Tem certeza?';

  @override
  String get moderationReviewModalDescription =>
      '''Considere como seu comentário pode fazer os outros se sentirem e certifique-se de seguir nossas Diretrizes da Comunidade.''';

  @override
  String get emptyMessagePreviewText => '';

  @override
  String get voiceRecordingText => 'Gravação de voz';

  @override
  String get audioAttachmentText => 'Áudio';

  @override
  String get imageAttachmentText => 'Imagem';

  @override
  String get videoAttachmentText => 'Vídeo';

  @override
  String get fileAttachmentText => 'Arquivo';

  @override
  String get linkAttachmentText => 'Link';

  @override
  String filesAttachmentCountText(int count) => count == 1 ? 'Arquivo' : '$count arquivos';

  @override
  String photosAttachmentCountText(int count) => count == 1 ? 'Foto' : '$count fotos';

  @override
  String videosAttachmentCountText(int count) => count == 1 ? 'Vídeo' : '$count vídeos';

  @override
  String get pollYouVotedText => 'Você votou';

  @override
  String pollSomeoneVotedText(String username) => '$username votou';

  @override
  String get pollYouCreatedText => 'Você criou';

  @override
  String pollSomeoneCreatedText(String username) => '$username criou';

  @override
  String get draftLabel => 'Rascunho';

  @override
  String locationLabel({bool isLive = false}) {
    if (isLive) return 'Localização ao Vivo';
    return 'Localização';
  }

  @override
  String get noConversationsYetText => 'Ainda não há conversas';

  @override
  String get replyToStartThreadText => 'Responda a uma mensagem para iniciar uma thread';

  @override
  String get sendMessageToStartConversationText => 'Envie uma mensagem para iniciar a conversa';

  @override
  String get savedForLaterLabel => 'Guardado para depois';

  @override
  String get repliedToThreadAnnotationLabel => 'Respondeu a uma thread';

  @override
  String get alsoSentInChannelAnnotationLabel => 'Também enviado no canal';

  @override
  String get viewLabel => 'Ver';

  @override
  String get reminderSetLabel => 'Lembrete definido';

  @override
  String reminderAtText(String time) => 'Hoje às $time';

  @override
  String get createPollPromptLabel => 'Crie uma enquete e deixe todos votarem!';

  @override
  String get takePhotoAndShareLabel => 'Tire uma foto e compartilhe';

  @override
  String get takeVideoAndShareLabel => 'Grave um vídeo e compartilhe';

  @override
  String get openCameraLabel => 'Abrir câmera';

  @override
  String get selectFilesToShareLabel => 'Selecione arquivos para compartilhar';

  @override
  String get openFilesLabel => 'Abrir arquivos';

  @override
  String get unsupportedAttachmentLabel => 'Anexo não suportado';

  @override
  String get confirmLabel => 'CONFIRMAR';

  @override
  String get emptyReactionsText => 'Ainda não há reações';

  @override
  String get loadingReactionsError => 'Erro ao carregar as reações';

  @override
  String get tapToRemoveReactionLabel => 'Toque para remover';

  @override
  String reactionsCountText(int count) => '$count reações';

  @override
  String get justNowLabel => 'Agora mesmo';

  @override
  String replyToUserLabel(String userName) => 'Responder a $userName';

  @override
  String get multipleAnswersDescription => 'Selecionar mais de uma opção';

  @override
  String maximumVotesPerPersonDescription([Range<int>? range]) {
    final (:min, :max) = range ?? (min: 2, max: 10);
    return 'Escolha entre $min\u2013$max opções';
  }

  @override
  String get anonymousPollDescription => 'Ocultar quem votou';

  @override
  String get suggestAnOptionDescription => 'Permitir que outros adicionem opções';

  @override
  String get addACommentDescription => 'Permitir que outros adicionem comentários';
}
