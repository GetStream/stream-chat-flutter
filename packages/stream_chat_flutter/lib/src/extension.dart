import 'package:characters/characters.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';
import 'package:stream_chat_flutter/src/localization/translations.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final _emojiChars = Emoji.chars();

/// String extension
extension StringExtension on String {
  /// Returns the capitalized string
  String capitalize() =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Returns whether the string contains only emoji's or not.
  ///
  ///  Emojis guidelines
  ///  1 to 3 emojis: big size with no text bubble.
  ///  4+ emojis or emojis+text: standard size with text bubble.
  bool get isOnlyEmoji {
    if (isEmpty) return false;
    if (length > 3) return false;
    final characters = trim().characters;
    return characters.every(_emojiChars.contains);
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
          bottomRight: bottomLeft)
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
  }) =>
      IconButton(
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
