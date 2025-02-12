import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {

  AppLocalizations(this.locale);
  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'add_a_group_name': 'Add a group name',
      'add_group_members': 'Add Group Members',
      'advanced_options': 'Advanced Options',
      'api_key_error': 'Please enter the Chat API Key',
      'attachment': 'attachment',
      'attachments': 'attachments',
      'cancel': 'Cancel',
      'chat_api_key': 'Chat API Key',
      'chats': 'Chats',
      'choose_a_group_chat_name': 'Choose a group chat name',
      'connected': 'Connected',
      'create_a_group': 'Create a Group',
      'custom_settings': 'Custom settings',
      'delete': 'Delete',
      'delete_conversation_are_you_sure':
          'Are you sure you want to delete this conversation?',
      'delete_conversation_title': 'Delete Conversation',
      'disconnected': 'Disconnected',
      'error_connecting': 'Error connecting, retry',
      'files': 'Files',
      'files_appear_here': 'Files sent in this chat will appear here',
      'group_shared_with_user_appear_here':
          'Group shared with User will appear here.',
      'last_seen': 'Last seen',
      'leave': 'Leave',
      'leave_conversation': 'Leave conversation',
      'leave_conversation_are_you_sure':
          'Are you sure you want to leave this conversation?',
      'leave_group': 'Leave Group',
      'loading': 'Loading...',
      'login': 'Login',
      'long_press_message': 'Long-press an important message and\nchoose',
      'matches_for': 'Matches for',
      'member': 'Member',
      'members': 'Members',
      'mentions': 'Mentions',
      'message': 'Message',
      'message_channel_description': 'Channel used for showing messages',
      'message_channel_name': 'Message channel',
      'more': 'more',
      'mute_group': 'Mute group',
      'mute_user': 'Mute user',
      'name': 'Name',
      'name_of_group_chat': 'Name of Group Chat',
      'new_chat': 'New Chat',
      'new_direct_message': 'New direct message',
      'new_group': 'New group',
      'no_chats_here_yet': 'No chats here yet...',
      'no_files': 'No Files',
      'no_media': 'No Media',
      'no_mentions_exist_yet': 'No mentions exist yet...',
      'no_pinned_items': 'No pinned items',
      'no_results': 'No results...',
      'no_shared_groups': 'No Shared Groups',
      'no_title': 'No title',
      'no_user_matches_these_keywords': 'No user matches these keywords...',
      'ok': 'OK',
      'online': 'Online',
      'on_the_platform': 'On the platform',
      'operation_could_not_be_completed':
          "The operation couldn't be completed.",
      'owner': 'Owner',
      'photos_and_videos': 'Photos & Videos',
      'photos_or_videos_will_appear_here':
          'Photos or videos sent in this chat will \nappear here',
      'pinned_messages': 'Pinned Messages',
      'pin_to_conversation': 'Pin to conversation',
      'reconnecting': 'Reconnecting...',
      'remove': 'Remove',
      'remove_from_group': 'Remove From Group',
      'remove_member': 'Remove member',
      'remove_member_are_you_sure':
          'Are you sure you want to remove this member?',
      'search': 'Search',
      'select_user_to_try_flutter_sdk': 'Select a user to try the Flutter SDK',
      'shared_groups': 'Shared Groups',
      'sign_out': 'Sign out',
      'something_went_wrong_error_message': 'Something went wrong',
      'stream_sdk': 'Stream SDK',
      'stream_test_account': 'Stream test account',
      'to': 'To',
      'type_a_name_hint': 'Type a name',
      'user_id': 'User ID',
      'user_id_error': 'Please enter the User ID',
      'username_optional': 'Username (optional)',
      'user_token': 'User Token',
      'user_token_error': 'Please enter the user token',
      'view_info': 'View info',
      'welcome_to_stream_chat': 'Welcome to Stream Chat',
    },
    'it': {
      'add_a_group_name': 'Aggiungi un nome al gruppo',
      'add_group_members': 'Aggiungi un membro',
      'advanced_options': 'Opzioni Avanzate',
      'api_key_error': "Per favore inserisci l'API Key",
      'attachment': 'allegato',
      'attachments': 'allegati',
      'cancel': 'Annulla',
      'chat_api_key': 'Chat API Key',
      'chats': 'Conversazioni',
      'choose_a_group_chat_name': 'Scegli un nome per il gruppo',
      'connected': 'Connesso',
      'create_a_group': 'Crea un Gruppo',
      'custom_settings': 'Opzioni Personalizzate',
      'delete': 'Cancella',
      'delete_conversation_are_you_sure':
          'Sei sicuro di voler eliminare la conversazione?',
      'delete_conversation_title': 'Elimina Conversazione',
      'disconnected': 'Disconnesso',
      'error_connecting': 'Errore durante la connessione, riprova',
      'files': 'File',
      'files_appear_here': 'I file inviati in questa chat compariranno qui',
      'group_shared_with_user_appear_here':
          "I gruppi in comune con quest'utente compariranno qui",
      'last_seen': 'Ultimo accesso',
      'leave': 'Lascia',
      'leave_conversation': 'Lascia conversazione',
      'leave_conversation_are_you_sure':
          'Sei sicuro di voler lasciare questa conversazione?',
      'leave_group': 'Lascia Gruppo',
      'loading': 'Caricamento...',
      'login': 'Login',
      'long_press_message': 'Premi a lungo su un messaggio importante e scegli',
      'matches_for': 'Risultati per',
      'member': 'Membro',
      'members': 'Membri',
      'mentions': 'Menzioni',
      'message': 'Messaggi',
      'message_channel_description': 'Canale usato per mostrare i messaggi',
      'message_channel_name': 'Invia un messaggio al canale',
      'more': 'altro',
      'mute_group': 'Silenzia gruppo',
      'mute_user': 'Silenzia utente',
      'name': 'Nome',
      'name_of_group_chat': 'Nome del gruppo',
      'new_chat': 'Nuova conversazione',
      'new_direct_message': 'Nuovo messaggio diretto',
      'new_group': 'Nuovo gruppo',
      'no_chats_here_yet': 'Ancora nessun messaggio...',
      'no_files': 'Nessun File',
      'no_media': 'Nessun Media',
      'no_mentions_exist_yet': 'Ancora nessuna menzione...',
      'no_pinned_items': 'Nessun messaggio in evidenza',
      'no_results': 'Nessun risultato...',
      'no_shared_groups': 'Nessun gruppo in comune',
      'no_title': 'Nessun titolo',
      'no_user_matches_these_keywords': 'Nessun utente per questa ricerca...',
      'ok': 'OK',
      'online': 'Online',
      'on_the_platform': 'Sulla piattaforma',
      'operation_could_not_be_completed':
          "Non é stato possibile completare l'operazione.",
      'owner': 'Proprietario',
      'photos_and_videos': 'Foto & Video',
      'photos_or_videos_will_appear_here':
          'Foto or video inviati in questa chat \ncompariranno qui',
      'pinned_messages': 'Messaggi in evidenza',
      'pin_to_conversation': 'Metti in evidenza',
      'reconnecting': 'Riconnessione...',
      'remove': 'Rimuovi',
      'remove_from_group': 'Rimuovi Dal Gruppo',
      'remove_member': 'Rimuovi membro',
      'remove_member_are_you_sure':
          'Sei sicuro di voler rimuovere questo membro?',
      'search': 'Cerca',
      'select_user_to_try_flutter_sdk':
          "Seleziona un utente per provare l'SDK Flutter",
      'shared_groups': 'Gruppi in comune',
      'sign_out': 'Sign out',
      'something_went_wrong_error_message': 'Qualcosa é andato storto',
      'stream_sdk': 'Stream SDK',
      'stream_test_account': 'Account di test',
      'to': 'A',
      'type_a_name_hint': 'Scrivi un nome',
      'user_id': 'User ID',
      'user_id_error': "Per favore inserisci l'ID dell'utente",
      'username_optional': 'Username (opzionale)',
      'user_token': 'Token Utente',
      'user_token_error': 'Per favore inserisci il token',
      'view_info': 'Vedi info',
      'welcome_to_stream_chat': 'Benvenuto in Stream Chat',
    },
  };

  final Locale locale;

  String get addAGroupName {
    return _localizedValues[locale.languageCode]!['add_a_group_name']!;
  }

  String get addGroupMembers {
    return _localizedValues[locale.languageCode]!['add_group_members']!;
  }

  String get advancedOptions {
    return _localizedValues[locale.languageCode]!['advanced_options']!;
  }

  String get apiKeyError {
    return _localizedValues[locale.languageCode]!['api_key_error']!;
  }

  String get attachment {
    return _localizedValues[locale.languageCode]!['attachment']!;
  }

  String get attachments {
    return _localizedValues[locale.languageCode]!['attachments']!;
  }

  String get cancel {
    return _localizedValues[locale.languageCode]!['cancel']!;
  }

  String get chatApiKey {
    return _localizedValues[locale.languageCode]!['chat_api_key']!;
  }

  String get chats {
    return _localizedValues[locale.languageCode]!['chats']!;
  }

  String get chooseAGroupChatName {
    return _localizedValues[locale.languageCode]!['choose_a_group_chat_name']!;
  }

  String get connected {
    return _localizedValues[locale.languageCode]!['connected']!;
  }

  String get createAGroup {
    return _localizedValues[locale.languageCode]!['create_a_group']!;
  }

  String get customSettings {
    return _localizedValues[locale.languageCode]!['custom_settings']!;
  }

  String get delete {
    return _localizedValues[locale.languageCode]!['delete']!;
  }

  String get deleteConversationAreYouSure {
    return _localizedValues[locale.languageCode]![
        'delete_conversation_are_you_sure']!;
  }

  String get deleteConversationTitle {
    return _localizedValues[locale.languageCode]!['delete_conversation_title']!;
  }

  String get disconnected {
    return _localizedValues[locale.languageCode]!['disconnected']!;
  }

  String get errorConnecting {
    return _localizedValues[locale.languageCode]!['error_connecting']!;
  }

  String get files {
    return _localizedValues[locale.languageCode]!['files']!;
  }

  String get filesAppearHere {
    return _localizedValues[locale.languageCode]!['files_appear_here']!;
  }

  String get groupSharedWithUserAppearHere {
    return _localizedValues[locale.languageCode]![
        'group_shared_with_user_appear_here']!;
  }

  String get lastSeen {
    return _localizedValues[locale.languageCode]!['last_seen']!;
  }

  String get leave {
    return _localizedValues[locale.languageCode]!['leave']!;
  }

  String get leaveConversation {
    return _localizedValues[locale.languageCode]!['leave_conversation']!;
  }

  String get leaveConversationAreYouSure {
    return _localizedValues[locale.languageCode]![
        'leave_conversation_are_you_sure']!;
  }

  String get leaveGroup {
    return _localizedValues[locale.languageCode]!['leave_group']!;
  }

  String get loading {
    return _localizedValues[locale.languageCode]!['loading']!;
  }

  String get login {
    return _localizedValues[locale.languageCode]!['login']!;
  }

  String get longPressMessage {
    return _localizedValues[locale.languageCode]!['long_press_message']!;
  }

  String get matchesFor {
    return _localizedValues[locale.languageCode]!['matches_for']!;
  }

  String get member {
    return _localizedValues[locale.languageCode]!['member']!;
  }

  String get members {
    return _localizedValues[locale.languageCode]!['members']!;
  }

  String get mentions {
    return _localizedValues[locale.languageCode]!['mentions']!;
  }

  String get message {
    return _localizedValues[locale.languageCode]!['message']!;
  }

  String get messageChannelDescription {
    return _localizedValues[locale.languageCode]![
        'message_channel_description']!;
  }

  String get messageChannelName {
    return _localizedValues[locale.languageCode]!['message_channel_name']!;
  }

  String get more {
    return _localizedValues[locale.languageCode]!['more']!;
  }

  String get muteGroup {
    return _localizedValues[locale.languageCode]!['mute_group']!;
  }

  String get muteUser {
    return _localizedValues[locale.languageCode]!['mute_user']!;
  }

  String get name {
    return _localizedValues[locale.languageCode]!['name']!;
  }

  String get nameOfGroupChat {
    return _localizedValues[locale.languageCode]!['name_of_group_chat']!;
  }

  String get newChat {
    return _localizedValues[locale.languageCode]!['new_chat']!;
  }

  String get newDirectMessage {
    return _localizedValues[locale.languageCode]!['new_direct_message']!;
  }

  String get newGroup {
    return _localizedValues[locale.languageCode]!['new_group']!;
  }

  String get noChatsHereYet {
    return _localizedValues[locale.languageCode]!['no_chats_here_yet']!;
  }

  String get noFiles {
    return _localizedValues[locale.languageCode]!['no_files']!;
  }

  String get noMedia {
    return _localizedValues[locale.languageCode]!['no_media']!;
  }

  String get noMentionsExistYet {
    return _localizedValues[locale.languageCode]!['no_mentions_exist_yet']!;
  }

  String get noPinnedItems {
    return _localizedValues[locale.languageCode]!['no_pinned_items']!;
  }

  String get noResults {
    return _localizedValues[locale.languageCode]!['no_results']!;
  }

  String get noSharedGroups {
    return _localizedValues[locale.languageCode]!['no_shared_groups']!;
  }

  String get noTitle {
    return _localizedValues[locale.languageCode]!['no_title']!;
  }

  String get noUserMatchesTheseKeywords {
    return _localizedValues[locale.languageCode]![
        'no_user_matches_these_keywords']!;
  }

  String get ok {
    return _localizedValues[locale.languageCode]!['ok']!;
  }

  String get online {
    return _localizedValues[locale.languageCode]!['online']!;
  }

  String get onThePlatorm {
    return _localizedValues[locale.languageCode]!['on_the_platform']!;
  }

  String get operationCouldNotBeCompleted {
    return _localizedValues[locale.languageCode]![
        'operation_could_not_be_completed']!;
  }

  String get owner {
    return _localizedValues[locale.languageCode]!['owner']!;
  }

  String get photosAndVideos {
    return _localizedValues[locale.languageCode]!['photos_and_videos']!;
  }

  String get photosOrVideosWillAppearHere {
    return _localizedValues[locale.languageCode]![
        'photos_or_videos_will_appear_here']!;
  }

  String get pinnedMessages {
    return _localizedValues[locale.languageCode]!['pinned_messages']!;
  }

  String get pinToConversation {
    return _localizedValues[locale.languageCode]!['pin_to_conversation']!;
  }

  String get reconnecting {
    return _localizedValues[locale.languageCode]!['reconnecting']!;
  }

  String get remove {
    return _localizedValues[locale.languageCode]!['remove']!;
  }

  String get removeFromGroup {
    return _localizedValues[locale.languageCode]!['remove_from_group']!;
  }

  String get removeMember {
    return _localizedValues[locale.languageCode]!['remove_member']!;
  }

  String get removeMemberAreYouSure {
    return _localizedValues[locale.languageCode]![
        'remove_member_are_you_sure']!;
  }

  String get search {
    return _localizedValues[locale.languageCode]!['search']!;
  }

  String get selectUserToTryFlutterSDK {
    return _localizedValues[locale.languageCode]![
        'select_user_to_try_flutter_sdk']!;
  }

  String get sharedGroups {
    return _localizedValues[locale.languageCode]!['shared_groups']!;
  }

  String get signOut {
    return _localizedValues[locale.languageCode]!['sign_out']!;
  }

  String get somethingWentWrongErrorMessage {
    return _localizedValues[locale.languageCode]![
        'something_went_wrong_error_message']!;
  }

  String get streamSDK {
    return _localizedValues[locale.languageCode]!['stream_sdk']!;
  }

  String get streamTestAccount {
    return _localizedValues[locale.languageCode]!['stream_test_account']!;
  }

  String get to {
    return _localizedValues[locale.languageCode]!['to']!;
  }

  String get typeANameHint {
    return _localizedValues[locale.languageCode]!['type_a_name_hint']!;
  }

  String get userId {
    return _localizedValues[locale.languageCode]!['user_id']!;
  }

  String get userIdError {
    return _localizedValues[locale.languageCode]!['user_id_error']!;
  }

  String get usernameOptional {
    return _localizedValues[locale.languageCode]!['username_optional']!;
  }

  String get userToken {
    return _localizedValues[locale.languageCode]!['user_token']!;
  }

  String get userTokenError {
    return _localizedValues[locale.languageCode]!['user_token_error']!;
  }

  String get viewInfo {
    return _localizedValues[locale.languageCode]!['view_info']!;
  }

  String get welcomeToStreamChat {
    return _localizedValues[locale.languageCode]!['welcome_to_stream_chat']!;
  }

  static List<String> languages() => _localizedValues.keys.toList();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.languages().contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
