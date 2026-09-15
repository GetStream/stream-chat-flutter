import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../../stream_chat_flutter.dart';

/// Displays contextual annotations above the message bubble for the given
/// message.
///
/// This widget delegates rendering to either a custom builder registered via
/// [StreamComponentFactory], or [DefaultStreamMessageHeader] when no custom
/// builder is provided. Register a custom builder through
/// `streamChatComponentBuilders(messageHeader: ...)` to fully replace the
/// default header rendering while still receiving the same
/// [StreamMessageHeaderProps].
///
/// See also:
///
///  * [StreamMessageHeaderProps], which holds every configurable property.
///  * [DefaultStreamMessageHeader], the default implementation used when no
///    custom builder is registered.
///  * [StreamMessageFooter], the symmetric slot below the message bubble.
class StreamMessageHeader extends core.NullableStatelessWidget {
  /// Creates a message header for the given [message].
  StreamMessageHeader({
    super.key,
    required Message message,
    VoidCallback? onViewChannelTap,
    bool showTranslatedText = true,
    VoidCallback? onToggleTranslatedText,
  }) : props = .new(
         message: message,
         onViewChannelTap: onViewChannelTap,
         showTranslatedText: showTranslatedText,
         onToggleTranslatedText: onToggleTranslatedText,
       );

  /// Creates a message header from pre-built [props].
  const StreamMessageHeader.fromProps({super.key, required this.props});

  /// The properties that configure this header.
  final StreamMessageHeaderProps props;

  @override
  Widget? nullableBuild(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMessageHeaderProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMessageHeader(props: props);
  }
}

/// Properties for configuring a [StreamMessageHeader].
///
/// See also:
///
///  * [StreamMessageHeader], which uses these properties.
///  * [DefaultStreamMessageHeader], the default implementation.
class StreamMessageHeaderProps {
  /// Creates properties for a message header.
  const StreamMessageHeaderProps({
    required this.message,
    this.onViewChannelTap,
    this.showTranslatedText = true,
    this.onToggleTranslatedText,
  });

  /// The message whose annotations to display.
  final Message message;

  /// Called when the "View" link in the show-in-channel annotation is tapped.
  final VoidCallback? onViewChannelTap;

  /// Whether [message] is currently displaying its translation from
  /// [Message.i18n] rather than its original text.
  ///
  /// Only relevant when a translation exists for the current user's
  /// language; ignored otherwise. Toggled via [onToggleTranslatedText].
  final bool showTranslatedText;

  /// Called when the "Show original"/"Show translation" link in the
  /// translation annotation is tapped.
  ///
  /// If null, the link is still rendered when a translation is available,
  /// but tapping it has no effect.
  final VoidCallback? onToggleTranslatedText;

  /// Returns a copy of this [StreamMessageHeaderProps] with the given fields
  /// replaced with new values.
  StreamMessageHeaderProps copyWith({
    Message? message,
    VoidCallback? onViewChannelTap,
    bool? showTranslatedText,
    VoidCallback? onToggleTranslatedText,
  }) {
    return StreamMessageHeaderProps(
      message: message ?? this.message,
      onViewChannelTap: onViewChannelTap ?? this.onViewChannelTap,
      showTranslatedText: showTranslatedText ?? this.showTranslatedText,
      onToggleTranslatedText: onToggleTranslatedText ?? this.onToggleTranslatedText,
    );
  }
}

/// The default implementation of [StreamMessageHeader].
///
/// Annotations are shown in the following order when applicable, per the
/// design system's mixed-annotation priority:
///
///  1. **Saved for later** — when a reminder exists without a scheduled time.
///  2. **Pinned** — when [Message.pinned] is true, showing who pinned it.
///  3. **Show in channel / Replied to thread** — when [Message.showInChannel]
///     is true. The label adapts based on whether the message list is a
///     channel or thread view, and includes a tappable "View" link that
///     invokes [StreamMessageHeaderProps.onViewChannelTap].
///  4. **Reminder** — when a reminder exists with a scheduled time.
///  5. **Translated** — when [Message.i18n] has a translation for the
///     current user's language, the message was not written in that language,
///     and [StreamMessageTranslationConfiguration.annotationEnabled] is set.
///     Reads "Translated from {language}" when the original language is
///     known, otherwise plain "Translated". Includes a "Show original"/"Show
///     translation" link that invokes
///     [StreamMessageHeaderProps.onToggleTranslatedText].
///
/// Returns `null` when no annotations apply, allowing the parent layout to
/// collapse the slot and skip spacing automatically.
class DefaultStreamMessageHeader extends core.NullableStatefulWidget {
  /// Creates a default message header with the given [props].
  const DefaultStreamMessageHeader({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamMessageHeaderProps props;

  @override
  core.NullableState<DefaultStreamMessageHeader> createState() => _DefaultStreamMessageHeaderState();
}

class _DefaultStreamMessageHeaderState extends core.NullableState<DefaultStreamMessageHeader> {
  late String? _language;
  StreamSubscription<String?>? _languageSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // `StreamChat.of` registers an inherited-widget dependency, so this (and
    // the `currentUserStream` subscription it seeds) must happen here rather
    // than in `initState`.
    final streamChat = StreamChat.of(context);
    _language = streamChat.currentUser?.language;
    final languageStream = streamChat.currentUserStream.map((it) => it?.language);
    _languageSubscription ??= languageStream.listen((language) {
      if (language == _language) return;
      setState(() => _language = language);
    });
  }

  @override
  void dispose() {
    _languageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget? nullableBuild(BuildContext context) {
    final props = widget.props;
    final message = props.message;
    final translations = context.translations;
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;
    final crossAxisAlignment = core.StreamMessageLayout.crossAxisAlignmentOf(context);

    // Previews sit on the modal scrim, where accent-colored annotations don't
    // have enough contrast, so they fall back to the on-scrim color.
    final isPreview = core.StreamMessageLayout.presentationOf(context) == .preview;
    final accentColor = isPreview ? colorScheme.textOnAccent : colorScheme.accentPrimary;
    final linkColor = isPreview ? colorScheme.textOnAccent : colorScheme.textLink;

    Widget? savedForLaterAnnotation;
    if (message.reminder case final reminder? when reminder.remindAt == null) {
      savedForLaterAnnotation = core.StreamMessageAnnotation(
        leading: Icon(icons.save),
        label: Text(translations.savedForLaterLabel),
        style: .from(textColor: accentColor, iconColor: accentColor),
      );
    }

    Widget? pinnedAnnotation;
    if (message.pinned case true) {
      final currentUser = StreamChat.of(context).currentUser!;
      final pinnedBy = message.pinnedBy ?? currentUser;

      pinnedAnnotation = core.StreamMessageAnnotation(
        leading: Icon(icons.pin),
        label: Text(translations.pinnedByUserText(pinnedBy: pinnedBy, currentUser: currentUser)),
      );
    }

    Widget? showInChannelAnnotation;
    if (message.showInChannel case true) {
      final listKind = core.StreamMessageLayout.listKindOf(context);
      final annotationLabel = switch (listKind) {
        .channel => translations.repliedToThreadAnnotationLabel,
        .thread => translations.alsoSentInChannelAnnotationLabel,
      };

      showInChannelAnnotation = core.StreamMessageAnnotation(
        onTap: props.onViewChannelTap,
        leading: Icon(icons.arrowUpRight),
        label: Text(annotationLabel),
        separator: core.StreamMessageAnnotation.separator,
        trailing: Text(translations.viewLabel),
        style: .from(trailingTextColor: linkColor),
      );
    }

    Widget? reminderAnnotation;
    if (message.reminder?.remindAt?.toLocal() case final remindAt?) {
      reminderAnnotation = core.StreamMessageAnnotation(
        leading: Icon(icons.bell),
        label: Text(translations.reminderSetLabel),
        separator: core.StreamMessageAnnotation.separator,
        trailing: Text(translations.reminderAtText(Jiffy.parseFromDateTime(remindAt).jm)),
      );
    }

    Widget? translatedAnnotation;
    final translationConfig = StreamChatConfiguration.of(context).messageTranslation;
    // Opt-in: without an annotation, translated messages are still shown
    // translated, just silently — the SDK's long-standing behaviour.
    if (translationConfig.enabled && translationConfig.annotationEnabled) {
      // A translation into the reader's own language is what there is to
      // toggle; `translatedText` returns null when there is nothing to show,
      // including for a reader of the language the message was written in.
      if (message.translatedText(_language) != null) {
        final label = switch (props.showTranslatedText) {
          false => translations.originalLabel,
          true => switch (message.originalLanguage) {
            null => translations.translatedLabel,
            final sourceLanguage => translations.translatedFromLanguageText(sourceLanguage),
          },
        };
        final trailing = props.showTranslatedText ? translations.showOriginalLabel : translations.showTranslationLabel;

        translatedAnnotation = core.StreamMessageAnnotation(
          onTap: props.onToggleTranslatedText,
          leading: Icon(icons.translate),
          label: Text('$label ·'),
          trailing: Text(trailing),
          style: .from(trailingTextColor: linkColor),
        );
      }
    }

    final children = [
      ?savedForLaterAnnotation,
      ?pinnedAnnotation,
      ?showInChannelAnnotation,
      ?reminderAnnotation,
      ?translatedAnnotation,
    ];

    if (children.isEmpty) return null;

    return core.StreamColumn(
      mainAxisSize: .min,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
