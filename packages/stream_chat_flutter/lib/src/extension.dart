import 'package:characters/characters.dart';
import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final _emojis = Emoji.all();

/// String extension
extension StringExtension on String {
  /// Returns the capitalized string
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns whether the string contains only emoji's or not.
  ///
  ///  Emojis guidelines
  ///  1 to 3 emojis: big size with no text bubble.
  ///  4+ emojis or emojis+text: standard size with text bubble.
  bool get isOnlyEmoji {
    final characters = trim().characters;
    if (characters.isEmpty) return false;
    if (characters.length > 3) return false;
    return characters.every((c) => _emojis.map((e) => e.char).contains(c));
  }
}

/// List extension
extension IterableX<T> on Iterable<T> {
  /// Insert any item<T> inBetween the list items
  List<T> insertBetween(T item) => expand((e) sync* {
        yield item;
        yield e;
      }).skip(1).toList(growable: false);
}

/// Useful extension for [PlatformFile]
extension PlatformFileX on PlatformFile {
  /// Converts the [PlatformFile] into [AttachmentFile]
  AttachmentFile get toAttachmentFile => AttachmentFile(
        path: path,
        name: name,
        bytes: bytes,
        size: size,
      );
}

extension InputDecorationX on InputDecoration {
  InputDecoration merge(InputDecoration other) {
    if (other == null) return this;
    return copyWith(
      icon: other?.icon,
      labelText: other?.labelText,
      labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      helperText: other?.helperText,
      helperStyle: helperStyle?.merge(other.helperStyle) ?? other.helperStyle,
      helperMaxLines: other?.helperMaxLines,
      hintText: other?.hintText,
      hintStyle: hintStyle?.merge(other.hintStyle) ?? other.hintStyle,
      hintTextDirection: other?.hintTextDirection,
      hintMaxLines: other?.hintMaxLines,
      errorText: other?.errorText,
      errorStyle: errorStyle?.merge(other.errorStyle) ?? other.errorStyle,
      errorMaxLines: other?.errorMaxLines,
      floatingLabelBehavior: other?.floatingLabelBehavior,
      isCollapsed: other?.isCollapsed,
      isDense: other?.isDense,
      contentPadding: other?.contentPadding,
      prefixIcon: other?.prefixIcon,
      prefix: other?.prefix,
      prefixText: other?.prefixText,
      prefixIconConstraints: other?.prefixIconConstraints,
      prefixStyle: prefixStyle?.merge(other.prefixStyle) ?? other.prefixStyle,
      suffixIcon: other?.suffixIcon,
      suffix: other?.suffix,
      suffixText: other?.suffixText,
      suffixStyle: suffixStyle?.merge(other.suffixStyle) ?? other.suffixStyle,
      suffixIconConstraints: other?.suffixIconConstraints,
      counter: other?.counter,
      counterText: other?.counterText,
      counterStyle:
          counterStyle?.merge(other.counterStyle) ?? other.counterStyle,
      filled: other?.filled,
      fillColor: other?.fillColor,
      focusColor: other?.focusColor,
      hoverColor: other?.hoverColor,
      errorBorder: other?.errorBorder,
      focusedBorder: other?.focusedBorder,
      focusedErrorBorder: other?.focusedErrorBorder,
      disabledBorder: other?.disabledBorder,
      enabledBorder: other?.enabledBorder,
      border: other?.border,
      enabled: other?.enabled,
      semanticCounterText: other?.semanticCounterText,
      alignLabelWithHint: other?.alignLabelWithHint,
    );
  }
}

extension BuildContextX on BuildContext {
  double get textScaleFactor =>
      MediaQuery.maybeOf(this)?.textScaleFactor ?? 1.0;
}
