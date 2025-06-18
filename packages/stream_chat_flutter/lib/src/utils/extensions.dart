import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:diacritic/diacritic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart'; // For compatibility with flutter web.
import 'package:image_size_getter/image_size_getter.dart' hide Size;
import 'package:stream_chat_flutter/src/audio/audio_playlist_state.dart';
import 'package:stream_chat_flutter/src/localization/translations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

int _byteUnitConversionFactor = 1024;

/// int extensions
extension IntExtension on int {
  /// Parses int in bytes to human readable size. Like: 17 KB
  /// instead of 17524 bytes;
  String toHumanReadableSize() {
    if (this <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (log(this) / log(_byteUnitConversionFactor)).floor();
    final numberValue =
        (this / pow(_byteUnitConversionFactor, i)).toStringAsFixed(2);
    final suffix = suffixes[i];
    return '$numberValue $suffix';
  }
}

/// Durations extensions.
extension DurationExtension on Duration {
  /// Transforms Duration to a minutes and seconds time. Like: 04:13.
  String toMinutesAndSeconds() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}

/// String extension
extension StringExtension on String {
  /// Returns the capitalized string
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// Returns the biggest line of a text.
  String biggestLine() {
    if (contains('\n')) {
      return split('\n')
          .reduce((curr, next) => curr.length > next.length ? curr : next);
    } else {
      return this;
    }
  }

  /// Returns whether the string contains only emoji's or not.
  ///
  ///  Emojis guidelines
  ///  1 to 3 emojis: big size with no text bubble.
  ///  4+ emojis or emojis+text: standard size with text bubble.
  bool get isOnlyEmoji {
    final trimmedString = trim();
    if (trimmedString.isEmpty) return false;
    if (trimmedString.characters.length > 3) return false;
    final emojiRegex = RegExp(
      r'^(\u00a9|\u00ae|\u200d|[\ufe00-\ufe0f]|[\u2600-\u27FF]|[\u2300-\u2bFF]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])+$',
      multiLine: true,
      caseSensitive: false,
    );
    return emojiRegex.hasMatch(trimmedString);
  }

  /// Removes accents and diacritics from the given String.
  String get diacriticsInsensitive => removeDiacritics(this);

  /// Levenshtein distance between this and [t].
  int levenshteinDistance(String t) => levenshtein(this, t);

  /// Returns a resized imageUrl with the given [width], [height], [resize]
  /// and [crop] if it is from Stream CDN or Dashboard.
  ///
  /// Read more at https://getstream.io/chat/docs/flutter-dart/file_uploads/?language=dart#image-resizing
  String getResizedImageUrl({
    // TODO: Are these sizes optimal? Consider web/desktop
    double width = 400,
    double height = 400,
    String /*clip|crop|scale|fill*/ resize = 'clip',
    String /*center|top|bottom|left|right*/ crop = 'center',
  }) {
    final uri = Uri.parse(this);
    final host = uri.host;

    final fromStreamCDN = host.endsWith('stream-io-cdn.com');
    final fromStreamDashboard = host.endsWith('stream-cloud-uploads.imgix.net');

    if (!fromStreamCDN && !fromStreamDashboard) return this;

    final queryParameters = {...uri.queryParameters};

    if (fromStreamCDN) {
      if (queryParameters['h'].isNullOrMatches('*') &&
          queryParameters['w'].isNullOrMatches('*') &&
          queryParameters['crop'].isNullOrMatches('*') &&
          queryParameters['resize'].isNullOrMatches('*')) {
        queryParameters['h'] = height.floor().toString();
        queryParameters['w'] = width.floor().toString();
        queryParameters['crop'] = crop;
        queryParameters['resize'] = resize;
      }
    } else if (fromStreamDashboard) {
      queryParameters['height'] = height.floor().toString();
      queryParameters['width'] = width.floor().toString();
      queryParameters['fit'] = crop;
    }

    return uri.replace(queryParameters: queryParameters).toString();
  }
}

/// List extension
extension IterableExtension<T> on Iterable<T> {
  /// Insert any item<T> inBetween the list items
  List<T> insertBetween(T item) => expand((e) sync* {
        yield item;
        yield e;
      }).skip(1).toList(growable: false);
}

/// Useful extension for [PlatformFile]
extension PlatformFileX on PlatformFile {
  /// Converts the [PlatformFile] into [AttachmentFile]
  AttachmentFile get toAttachmentFile {
    return AttachmentFile(
      // Path is not supported on web.
      path: CurrentPlatform.isWeb ? null : path,
      name: name,
      bytes: bytes,
      size: size,
    );
  }

  /// Converts the [PlatformFile] to a [Attachment].
  Attachment toAttachment({required String type}) {
    final file = toAttachmentFile;
    final extraDataMap = <String, Object>{};

    final mimeType = file.mediaType?.mimeType;

    if (mimeType != null) {
      extraDataMap['mime_type'] = mimeType;
    }

    extraDataMap['file_size'] = file.size!;

    final attachment = Attachment(
      file: file,
      type: type,
      extraData: extraDataMap,
    );

    return attachment;
  }
}

/// Useful extension for [XFile]
extension XFileX on XFile {
  /// Converts the [PlatformFile] into [AttachmentFile]
  Future<AttachmentFile> get toAttachmentFile async {
    final bytes = await readAsBytes();
    return AttachmentFile(
      // Path is not supported on web.
      path: CurrentPlatform.isWeb ? null : path,
      name: name,
      size: bytes.length,
      bytes: bytes,
    );
  }

  /// Converts the [XFile] to a [Attachment].
  Future<Attachment> toAttachment({required String type}) async {
    final file = await toAttachmentFile;

    final extraDataMap = <String, Object>{};

    final mimeType = this.mimeType ?? file.mediaType?.mimeType;

    if (mimeType != null) {
      extraDataMap['mime_type'] = mimeType;
    }

    extraDataMap['file_size'] = file.size!;

    final attachment = Attachment(
      file: file,
      type: type,
      extraData: extraDataMap,
    );

    return attachment;
  }
}

/// Extension on [InputDecoration]
extension InputDecorationX on InputDecoration {
  /// Merges this [InputDecoration] with the [other]
  InputDecoration merge(InputDecoration? other) {
    if (other == null) return this;
    return copyWith(
      icon: other.icon,
      labelText: other.labelText,
      labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      helperText: other.helperText,
      helperStyle: helperStyle?.merge(other.helperStyle) ?? other.helperStyle,
      helperMaxLines: other.helperMaxLines,
      hintText: other.hintText,
      hintStyle: hintStyle?.merge(other.hintStyle) ?? other.hintStyle,
      hintTextDirection: other.hintTextDirection,
      hintMaxLines: other.hintMaxLines,
      errorText: other.errorText,
      errorStyle: errorStyle?.merge(other.errorStyle) ?? other.errorStyle,
      errorMaxLines: other.errorMaxLines,
      floatingLabelBehavior: other.floatingLabelBehavior,
      isCollapsed: other.isCollapsed,
      isDense: other.isDense,
      contentPadding: other.contentPadding,
      prefixIcon: other.prefixIcon,
      prefix: other.prefix,
      prefixText: other.prefixText,
      prefixIconConstraints: other.prefixIconConstraints,
      prefixStyle: prefixStyle?.merge(other.prefixStyle) ?? other.prefixStyle,
      suffixIcon: other.suffixIcon,
      suffix: other.suffix,
      suffixText: other.suffixText,
      suffixStyle: suffixStyle?.merge(other.suffixStyle) ?? other.suffixStyle,
      suffixIconConstraints: other.suffixIconConstraints,
      counter: other.counter,
      counterText: other.counterText,
      counterStyle:
          counterStyle?.merge(other.counterStyle) ?? other.counterStyle,
      filled: other.filled,
      fillColor: other.fillColor,
      focusColor: other.focusColor,
      hoverColor: other.hoverColor,
      errorBorder: other.errorBorder,
      focusedBorder: other.focusedBorder,
      focusedErrorBorder: other.focusedErrorBorder,
      disabledBorder: other.disabledBorder,
      enabledBorder: other.enabledBorder,
      border: other.border,
      enabled: other.enabled,
      semanticCounterText: other.semanticCounterText,
      alignLabelWithHint: other.alignLabelWithHint,
    );
  }
}

/// Gets text scale factor through context
extension BuildContextX on BuildContext {
  // ignore: public_member_api_docs
  double get textScaleFactor =>
      // ignore: deprecated_member_use
      MediaQuery.maybeOf(this)?.textScaleFactor ?? 1.0;

  /// Retrieves current translations according to locale
  /// Defaults to [DefaultTranslations]
  Translations get translations =>
      StreamChatLocalizations.of(this) ?? DefaultTranslations.instance;
}

/// Extension on [BorderRadius]
extension FlipBorder on BorderRadius {
  /// Flips borders (Y)
  BorderRadius mirrorBorderIfReversed({bool reverse = true}) => reverse
      ? BorderRadius.only(
          topLeft: topRight,
          topRight: topLeft,
          bottomLeft: bottomRight,
          bottomRight: bottomLeft,
        )
      : this;
}

/// Extension on [IconButton]
extension IconButtonX on IconButton {
  /// Creates a copy of [IconButton] with specified attributes overridden.
  IconButton copyWith({
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    void Function()? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool? autofocus,
    String? tooltip,
    bool? enableFeedback,
    BoxConstraints? constraints,
    Widget? icon,
  }) {
    return IconButton(
      iconSize: iconSize ?? this.iconSize,
      visualDensity: visualDensity ?? this.visualDensity,
      padding: padding ?? this.padding,
      alignment: alignment ?? this.alignment,
      splashRadius: splashRadius ?? this.splashRadius,
      color: color ?? this.color,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      highlightColor: highlightColor ?? this.highlightColor,
      splashColor: splashColor ?? this.splashColor,
      disabledColor: disabledColor ?? this.disabledColor,
      onPressed: onPressed ?? this.onPressed,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      focusNode: focusNode ?? this.focusNode,
      autofocus: autofocus ?? this.autofocus,
      tooltip: tooltip ?? this.tooltip,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      constraints: constraints ?? this.constraints,
      icon: icon ?? this.icon,
    );
  }
}

/// Extensions on List<User>
extension UserListX on List<User> {
  /// It does an search on a list of [User] and returns users with
  /// `id` or `name` containing the [query].
  ///
  /// Results are returned sorted by their edit distance from the
  /// searched string, distance is calculated using the [levenshtein] algorithm.
  List<User> search(String query) {
    String normalize(String input) => input.toLowerCase().diacriticsInsensitive;

    final normalizedQuery = normalize(query);

    final matchingUsers = <User, int>{}; // User:lDistance

    for (final user in this) {
      final normalizedId = normalize(user.id);
      final normalizedUserName = normalize(user.name);
      final lDistance = normalizedUserName.levenshteinDistance(normalizedQuery);
      final containsId = normalizedId.contains(normalizedQuery);
      final containsName = normalizedUserName.contains(normalizedQuery);
      if (lDistance < 3 || containsId || containsName) {
        matchingUsers[user] = lDistance;
      }
    }

    final entries = matchingUsers.entries.toList(growable: false)
      ..sort((prev, curr) {
        bool containsQuery(User user) =>
            normalize(user.id).contains(normalizedQuery) ||
            normalize(user.name).contains(normalizedQuery);

        final containsInPrev = containsQuery(prev.key);
        final containsInCurr = containsQuery(curr.key);

        if (containsInPrev && !containsInCurr) {
          return -1;
        } else if (!containsInPrev && containsInCurr) {
          return 1;
        }
        return prev.value.compareTo(curr.value);
      });

    return entries.map((e) => e.key).toList(growable: false);
  }
}

/// Extensions on Message
extension MessageX on Message {
  /// It replaces the user mentions with the actual user names.
  Message replaceMentions({bool linkify = true}) {
    var messageTextToRender = text;
    for (final user in mentionedUsers.toSet()) {
      final userId = user.id;
      final userName = user.name;
      if (linkify) {
        messageTextToRender = messageTextToRender?.replaceAll(
          RegExp('@($userId|$userName)'),
          '[@$userName]($userId)',
        );
      } else {
        messageTextToRender = messageTextToRender?.replaceAll(
          RegExp('@($userId|$userName)'),
          '@$userName',
        );
      }
    }
    return copyWith(text: messageTextToRender);
  }

  /// Returns an approximation of message size
  double roughMessageSize(double? fontSize) {
    var messageTextLength = min(text?.biggestLine().length ?? 0, 65);

    if (quotedMessage != null) {
      var quotedMessageLength =
          (min(quotedMessage!.text?.biggestLine().length ?? 0, 65)) + 8;

      if (quotedMessage!.attachments.isNotEmpty) {
        quotedMessageLength += 8;
      }

      if (quotedMessageLength > messageTextLength * 1.2) {
        messageTextLength = quotedMessageLength;
      }
    }

    // Quoted message have a smaller font, so it is necessary to reduce the
    // size of the multiplier to count for the smaller font.
    var multiplier = 0.55;
    if (quotedMessage != null) {
      multiplier = 0.45;
    }

    return messageTextLength * (fontSize ?? 1) * multiplier;
  }

  /// It returns the message with the translated text if available locally
  Message translate(String language) =>
      copyWith(text: i18n?['${language}_text'] ?? text);

  /// It returns the message replacing the mentioned user names with
  ///  the respective user ids
  Message replaceMentionsWithId() {
    if (mentionedUsers.isEmpty) return this;

    var messageTextToSend = text;
    if (messageTextToSend == null) return this;

    for (final user in mentionedUsers.toSet()) {
      final userName = user.name;
      messageTextToSend = messageTextToSend!.replaceAll(
        '@$userName',
        '@${user.id}',
      );
    }

    return copyWith(text: messageTextToSend);
  }
}

/// Extensions on [Uri]
extension UriX on Uri {
  /// Return the URI adding the http scheme if it is missing
  Uri get withScheme {
    if (hasScheme) return this;
    return Uri.parse('http://${toString()}');
  }
}

/// Extensions on generic type [T]
extension TypeX<T> on T? {
  /// Returns true if the value is null or matches the given [value]
  /// otherwise returns false.
  bool isNullOrMatches(T value) => this == null || this == value;
}

/// Useful extensions on [FileType]
extension FileTypeX on FileType {
  /// Converts the [FileType] to a [String].
  String toAttachmentType() {
    switch (this) {
      case FileType.image:
        return AttachmentType.image;
      case FileType.video:
        return AttachmentType.video;
      case FileType.audio:
        return AttachmentType.audio;
      case FileType.any:
      case FileType.media:
      case FileType.custom:
        return AttachmentType.file;
    }
  }
}

/// Useful extensions on [AttachmentPickerType]
extension AttachmentPickerTypeX on AttachmentPickerType {
  /// Converts the [AttachmentPickerType] to a [FileType].
  FileType get fileType {
    switch (this) {
      case AttachmentPickerType.images:
        return FileType.image;
      case AttachmentPickerType.videos:
        return FileType.video;
      case AttachmentPickerType.files:
        return FileType.any;
      case AttachmentPickerType.audios:
        return FileType.audio;
      case AttachmentPickerType.poll:
        throw Exception('Polls do not have a file type');
    }
  }
}

/// Useful extensions on [BoxConstraints].
extension ConstraintsX on BoxConstraints {
  /// Returns new box constraints that tightens the max width and max height
  /// to the given [size].
  BoxConstraints tightenMaxSize(Size? size) {
    if (size == null) return this;
    return copyWith(
      maxWidth: clampDouble(size.width, minWidth, maxWidth),
      maxHeight: clampDouble(size.height, minHeight, maxHeight),
    );
  }
}

/// Useful extensions on [Attachment].
extension OriginalSizeX on Attachment {
  /// Returns the size of the attachment if it is an image or giffy.
  /// Otherwise, returns null.
  Size? get originalSize {
    // Return null if the attachment is not an image or giffy.
    if (type != AttachmentType.image && type != AttachmentType.giphy) {
      return null;
    }

    // Calculate size locally if the attachment is not uploaded yet.
    final file = this.file;
    if (file != null) {
      ImageInput? input;
      if (file.bytes != null) {
        input = MemoryInput(file.bytes!);
      } else if (file.path != null) {
        input = FileInput(File(file.path!));
      }

      // Return null if the file does not contain enough information.
      if (input == null) return null;

      try {
        final size = ImageSizeGetter.getSizeResult(input).size;
        if (size.needRotate) {
          return Size(size.height.toDouble(), size.width.toDouble());
        }
        return Size(size.width.toDouble(), size.height.toDouble());
      } catch (e, stk) {
        debugPrint('Error getting image size: $e\n$stk');
        return null;
      }
    }

    // Otherwise, use the size provided by the server.
    final width = originalWidth;
    final height = originalHeight;
    if (width == null || height == null) return null;
    return Size(width.toDouble(), height.toDouble());
  }
}

/// Useful extensions on [List<Message>].
extension MessageListX on Iterable<Message> {
  /// Returns the last unread message in the list.
  /// Returns null if the list is empty or the userRead is null.
  ///
  /// The [userRead] is the last read message by the user.
  ///
  /// The last unread message is the last message in the list that is not
  /// sent by the current user and is sent after the last read message.
  @Deprecated("Use 'StreamChannel.getFirstUnreadMessage' instead.")
  Message? lastUnreadMessage(Read? userRead) {
    if (isEmpty || userRead == null) return null;

    if (first.createdAt.isAfter(userRead.lastRead) &&
        last.createdAt.isBefore(userRead.lastRead)) {
      return lastWhereOrNull(
        (it) =>
            it.user?.id != userRead.user.id &&
            it.id != userRead.lastReadMessageId &&
            it.createdAt.compareTo(userRead.lastRead) > 0,
      );
    }

    return null;
  }
}

/// Useful extensions on [ChannelModel].
extension ChannelModelX on ChannelModel {
  /// Returns the channel name if exists, or a formatted name based on the
  /// members of the channel and the [maxMembers] allowed.
  String? formatName({
    User? currentUser,
    int maxMembers = 2,
  }) {
    // If there's an assigned name and it's not empty, we use it.
    if (name case final name? when name.isNotEmpty) return name;

    // If there are no members, we return null.
    final members = this.members;
    if (members == null) return null;

    final otherMembers = members.where((it) => it.userId != currentUser?.id);

    // If there are no other members, we return the name of the current user.
    if (otherMembers.isEmpty) return currentUser?.name;

    // Otherwise, we return the names of the first `maxMembers` members sorted
    // alphabetically, followed by the number of remaining members if there are
    // more than `maxMembers` members.
    final memberNames = otherMembers
        .map((it) => it.user?.name)
        .whereType<String>()
        .take(maxMembers)
        .sorted();

    return switch (otherMembers.length <= maxMembers) {
      true => memberNames.join(', '),
      false =>
        '${memberNames.join(', ')} + ${otherMembers.length - maxMembers}',
    };
  }
}

/// {@template voiceRecordingAttachmentExtension}
/// Extension on [Attachment] to provide the voice recording attachment specific
/// properties.
/// {@endtemplate}
extension VoiceRecordingAttachmentExtension on Attachment {
  /// Returns the duration of the voice recording attachment if available else
  /// returns [Duration.zero].
  Duration get duration {
    final duration = extraData['duration'] as num?;
    if (duration == null) return Duration.zero;

    return Duration(milliseconds: duration.round() * 1000);
  }

  /// Returns the waveform data of the voice recording attachment if available
  /// else returns an empty list.
  List<double> get waveform {
    final waveform = extraData['waveform_data'] as List<dynamic>?;
    if (waveform == null) return [];

    return [...waveform.map((e) => double.tryParse(e.toString())).nonNulls];
  }
}

/// {@template attachmentPlaylistExtension}
/// Extension on [Iterable<Attachment>] to provide the playlist specific
/// properties.
/// {@endtemplate}
extension AttachmentPlaylistExtension on Iterable<Attachment> {
  /// Converts the list of attachments to a list of [PlaylistTrack].
  List<PlaylistTrack> toPlaylist() {
    return [
      ...map((it) {
        final uri = switch (it.uploadState) {
          Preparing() || InProgress() || Failed() => () {
              if (CurrentPlatform.isWeb) {
                final bytes = it.file?.bytes;
                final mimeType = it.file?.mediaType?.mimeType;
                if (bytes == null || mimeType == null) return null;

                return Uri.dataFromBytes(bytes, mimeType: mimeType);
              }

              final path = it.file?.path;
              if (path == null) return null;

              return Uri.file(path, windows: CurrentPlatform.isWindows);
            }(),
          Success() => () {
              final url = it.assetUrl;
              if (url == null) return null;

              return Uri.tryParse(url);
            }(),
        };

        if (uri == null) return null;

        return PlaylistTrack(
          uri: uri,
          title: it.title,
          waveform: it.waveform,
          duration: it.duration,
        );
      }).nonNulls,
    ];
  }
}

/// Extension to convert [AlignmentGeometry] to the corresponding
/// [CrossAxisAlignment].
extension ColumnAlignmentExtension on AlignmentGeometry {
  /// Converts an [AlignmentGeometry] to the most appropriate
  /// [CrossAxisAlignment] value.
  CrossAxisAlignment toColumnCrossAxisAlignment() {
    final x = switch (this) {
      Alignment(x: final x) => x,
      AlignmentDirectional(start: final start) => start,
      _ => null,
    };

    // If the alignment is unknown, fallback to the center alignment.
    if (x == null) return CrossAxisAlignment.center;

    return switch (x) {
      0.0 => CrossAxisAlignment.center,
      < 0 => CrossAxisAlignment.start,
      > 0 => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.center, // fallback (in case of NaN etc)
    };
  }
}
