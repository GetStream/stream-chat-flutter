import 'dart:math';

import 'package:diacritic/diacritic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter/src/localization/translations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
      r'^(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])+$',
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
      path: kIsWeb ? null : path,
      name: name,
      bytes: bytes,
      size: size,
    );
  }

  /// Converts the [PlatformFile] to a [Attachment].
  Attachment toAttachment({required String type}) {
    final file = toAttachmentFile;
    final extraDataMap = <String, Object>{};

    final mimeType = file.mimeType?.mimeType;

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
      name: name,
      size: bytes.length,
      path: path,
      bytes: bytes,
    );
  }

  /// Converts the [XFile] to a [Attachment].
  Future<Attachment> toAttachment({required String type}) async {
    final file = await toAttachmentFile;

    final extraDataMap = <String, Object>{};

    final mimeType = this.mimeType ?? file.mimeType?.mimeType;

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
          '@$userId',
          '[@$userName](@${userName.replaceAll(' ', '')})',
        );
      } else {
        messageTextToRender = messageTextToRender?.replaceAll(
          '@$userId',
          '@$userName',
        );
      }
    }
    return copyWith(text: messageTextToRender);
  }

  /// Returns an approximation of message size
  double roughMessageSize(double? fontSize) {
    var messageTextLength = min(text!.biggestLine().length, 65);

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
    var multiplier = 1.2;
    if (quotedMessage != null) {
      multiplier = 1;
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
        return 'image';
      case FileType.video:
        return 'video';
      case FileType.audio:
        return 'audio';
      case FileType.any:
      case FileType.media:
      case FileType.custom:
        return 'file';
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
    }
  }
}

/// Useful extensions on [StreamSvgIcon].
extension StreamSvgIconX on StreamSvgIcon {
  /// Converts the [StreamSvgIcon] to a [StreamIconThemeSvgIcon].
  StreamIconThemeSvgIcon toIconThemeSvgIcon() {
    return StreamIconThemeSvgIcon.fromStreamSvgIcon(this);
  }
}
