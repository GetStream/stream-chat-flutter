import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:xp_dart/xp_dart.dart';

import 'xp_stream_theme.dart';

/// Component builders that render the SDK's core components with `xp_dart`
/// widgets: buttons, checkboxes, switches, text inputs, progress bars and
/// loading spinners, plus Luna title-bar chrome for app bars and sheet headers.
///
/// Pass [extensions] to keep the app's own chat component overrides.
StreamComponentBuilders xpComponentBuilders({
  Iterable<StreamComponentBuilderExtension<Object>>? extensions,
}) {
  return StreamComponentBuilders(
    appBar: (context, props) => XpAppBar(props: props),
    sheetHeader: (context, props) => XpSheetHeader(props: props),
    button: (context, props) => XpStreamButton(props: props),
    checkbox: (context, props) => Semantics(
      checked: props.value,
      label: props.semanticLabel,
      child: XPCheckbox(value: props.value, onChanged: props.onChanged),
    ),
    // XP had no toggle switches; a checkbox is the native equivalent.
    toggleSwitch: (context, props) => Semantics(
      toggled: props.value,
      label: props.semanticLabel,
      child: XPCheckbox(value: props.value, onChanged: props.onChanged),
    ),
    textInput: (context, props) => XpTextInput(props: props),
    progressBar: (context, props) => XPProgressBar(
      value: props.value,
      height: math.max(props.minHeight ?? 14, 8),
    ),
    loadingSpinner: (context, props) => XpLoadingSpinner(props: props),
    extensions: extensions,
  );
}

// Marks the subtree of a Luna title bar so buttons inside it render as the
// blue window-control buttons instead of beige push buttons.
class _XpTitleBarScope extends InheritedWidget {
  const _XpTitleBarScope({required super.child});

  static bool of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_XpTitleBarScope>() != null;

  @override
  bool updateShouldNotify(_XpTitleBarScope oldWidget) => false;
}

const _xpTitleTextStyle = TextStyle(
  // Trebuchet MS ships on iOS and macOS; elsewhere the bundled Tahoma Bold stands in.
  fontFamily: 'Trebuchet MS',
  fontFamilyFallback: [xpFontFamily, ...xpFontFamilyFallback],
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: XPColors.buttonHighlight,
  shadows: [Shadow(offset: Offset(1, 1), color: Color(0xFF0F1089))],
);

const _xpSubtitleTextStyle = TextStyle(
  fontFamily: xpFontFamily,
  fontFamilyFallback: xpFontFamilyFallback,
  fontSize: 12,
  color: Color(0xFFDDE8FF),
);

/// A [StreamAppBar] drawn as a Luna window title bar.
class XpAppBar extends StatelessWidget {
  /// Creates an XP app bar from the SDK's app bar [props].
  const XpAppBar({super.key, required this.props});

  /// The properties the SDK passed for this app bar.
  final StreamAppBarProps props;

  @override
  Widget build(BuildContext context) {
    const xpStyle = StreamAppBarStyle(
      surfaceStyle: StreamSurfaceStyle.regular,
      backgroundColor: Colors.transparent,
      floatingBackgroundColor: Colors.transparent,
      titleTextStyle: _xpTitleTextStyle,
      subtitleTextStyle: _xpSubtitleTextStyle,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: xpTitleBarGradient),
      child: _XpTitleBarScope(
        child: IconTheme.merge(
          data: const IconThemeData(color: XPColors.buttonHighlight),
          child: DefaultStreamAppBar(
            props: StreamAppBarProps(
              leading: props.leading,
              automaticallyImplyLeading: props.automaticallyImplyLeading,
              title: props.title,
              subtitle: _onTitleBar(props.subtitle),
              trailing: props.trailing,
              primary: props.primary,
              excludeHeaderSemantics: props.excludeHeaderSemantics,
              style: props.style?.merge(xpStyle) ?? xpStyle,
            ),
          ),
        ),
      ),
    );
  }
}

// Subtitles often carry an explicit secondary text color that is unreadable on
// the blue title bar, so tint them to the title bar's light text color.
Widget? _onTitleBar(Widget? subtitle) {
  if (subtitle == null) return null;
  return ColorFiltered(
    colorFilter: ColorFilter.mode(_xpSubtitleTextStyle.color!, BlendMode.srcIn),
    child: subtitle,
  );
}

/// A [StreamSheetHeader] drawn as a Luna window title bar, so sheets and
/// dialogs read as XP windows.
class XpSheetHeader extends StatelessWidget {
  /// Creates an XP sheet header from the SDK's sheet header [props].
  const XpSheetHeader({super.key, required this.props});

  /// The properties the SDK passed for this sheet header.
  final StreamSheetHeaderProps props;

  @override
  Widget build(BuildContext context) {
    const xpStyle = StreamSheetHeaderStyle(
      titleTextStyle: _xpTitleTextStyle,
      subtitleTextStyle: _xpSubtitleTextStyle,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: xpTitleBarGradient),
      child: _XpTitleBarScope(
        child: IconTheme.merge(
          data: const IconThemeData(color: XPColors.buttonHighlight),
          child: DefaultStreamSheetHeader(
            props: StreamSheetHeaderProps(
              leading: props.leading,
              automaticallyImplyLeading: props.automaticallyImplyLeading,
              title: props.title,
              subtitle: _onTitleBar(props.subtitle),
              trailing: props.trailing,
              primary: props.primary,
              excludeHeaderSemantics: props.excludeHeaderSemantics,
              style: props.style?.merge(xpStyle) ?? xpStyle,
            ),
          ),
        ),
      ),
    );
  }
}

/// A [StreamButton] rendered as an [XPButton], or as a Luna window-control
/// button when it sits inside an XP title bar.
class XpStreamButton extends StatelessWidget {
  /// Creates an XP button from the SDK's button [props].
  const XpStreamButton({super.key, required this.props});

  /// The properties the SDK passed for this button.
  final StreamButtonProps props;

  @override
  Widget build(BuildContext context) {
    final enabled = props.onPressed != null;
    final isIconOnly = props.child == null;
    final height = switch (props.size) {
      StreamButtonSize.small => 28.0,
      StreamButtonSize.medium => 32.0,
      StreamButtonSize.large => 36.0,
    };

    Widget button;
    if (_XpTitleBarScope.of(context)) {
      button = _XpTitleBarButton(
        onPressed: props.onPressed,
        size: height,
        child: _content(XPColors.buttonHighlight),
      );
    } else {
      final foreground = switch ((enabled, props.style)) {
        (false, _) => XPColors.textDisabled,
        (true, StreamButtonStyle.destructive) => xpCloseRed,
        (true, _) => XPColors.text,
      };
      button = XPButton(
        onPressed: props.onPressed,
        autofocus: props.autofocus,
        minWidth: isIconOnly ? height : 75,
        minHeight: height,
        padding: isIconOnly ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 12),
        child: _content(foreground),
      );
    }

    button = Semantics(
      button: true,
      enabled: enabled,
      selected: props.isSelected,
      label: props.tooltip,
      child: button,
    );

    if (props.tooltip case final tooltip?) {
      button = Tooltip(message: tooltip, child: button);
    }

    return button;
  }

  Widget _content(Color foreground) {
    return IconTheme.merge(
      data: IconThemeData(color: foreground, size: 18),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: foreground,
          fontFamily: xpFontFamily,
          fontFamilyFallback: xpFontFamilyFallback,
          fontSize: 13,
          fontWeight: props.style == StreamButtonStyle.primary ? FontWeight.bold : FontWeight.normal,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [?props.iconLeft, ?props.child, ?props.iconRight],
        ),
      ),
    );
  }
}

// The blue, white-bordered square of the XP minimize / maximize buttons.
class _XpTitleBarButton extends StatefulWidget {
  const _XpTitleBarButton({required this.onPressed, required this.size, required this.child});

  final VoidCallback? onPressed;
  final double size;
  final Widget child;

  @override
  State<_XpTitleBarButton> createState() => _XpTitleBarButtonState();
}

class _XpTitleBarButtonState extends State<_XpTitleBarButton> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          constraints: BoxConstraints(minWidth: widget.size, minHeight: widget.size),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: XPColors.buttonHighlight),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _pressed
                  ? const [Color(0xFF1C47C2), Color(0xFF3C7CF0)]
                  : const [Color(0xFF6A9CF7), Color(0xFF2558E0)],
            ),
          ),
          child: Center(widthFactor: 1, heightFactor: 1, child: widget.child),
        ),
      ),
    );
  }
}

/// A [StreamTextInput] rendered as an [XPTextField].
///
/// [XPTextField] owns its focus node and supports a single line only, so inputs
/// that need a caller focus node, formatters, an initial value, multiple lines,
/// read-only mode or tap handling fall back to the default SDK input (which
/// still picks up the XP color scheme).
class XpTextInput extends StatelessWidget {
  /// Creates an XP text input from the SDK's text input [props].
  const XpTextInput({super.key, required this.props});

  /// The properties the SDK passed for this text input.
  final StreamTextInputProps props;

  bool get _isXpCompatible =>
      props.focusNode == null &&
      props.initialValue == null &&
      props.inputFormatters == null &&
      props.maxLines == 1 &&
      !props.readOnly &&
      props.onTap == null;

  @override
  Widget build(BuildContext context) {
    if (!_isXpCompatible) return DefaultStreamTextInput(props: props);

    Widget input = XPTextField(
      controller: props.controller,
      onChanged: props.onChanged,
      onSubmitted: (value) {
        props.onSubmitted?.call(value);
        props.onEditingComplete?.call();
      },
      enabled: props.enabled,
      autofocus: props.autofocus,
      placeholder: props.hintText,
    );

    if (props.leading != null || props.trailing != null) {
      input = IconTheme.merge(
        data: const IconThemeData(color: XPColors.buttonShadow, size: 18),
        child: Row(
          spacing: 6,
          children: [
            ?props.leading,
            Expanded(child: input),
            ?props.trailing,
          ],
        ),
      );
    }

    final label = props.labelText;
    final helper = props.helperText;
    if (label == null && helper == null) return input;

    const textStyle = TextStyle(fontFamily: xpFontFamily, fontFamilyFallback: xpFontFamilyFallback, fontSize: 12);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (label != null) Text(label, style: textStyle.copyWith(color: XPColors.text)),
        input,
        if (helper != null)
          Text(
            helper,
            style: textStyle.copyWith(
              color: switch (props.helperState) {
                StreamHelperState.error => xpCloseRed,
                StreamHelperState.success => xpStartGreen,
                _ => XPColors.textDisabled,
              },
            ),
          ),
      ],
    );
  }
}

/// A [StreamLoadingSpinner] rendered as an XP progress bar: the sliding
/// indeterminate animation, or the segmented green bar when a value is known.
class XpLoadingSpinner extends StatelessWidget {
  /// Creates an XP loading indicator from the SDK's spinner [props].
  const XpLoadingSpinner({super.key, required this.props});

  /// The properties the SDK passed for this spinner.
  final StreamLoadingSpinnerProps props;

  @override
  Widget build(BuildContext context) {
    final dimension = switch (props.size ?? StreamLoadingSpinnerSize.md) {
      StreamLoadingSpinnerSize.lg => 32.0,
      StreamLoadingSpinnerSize.md => 24.0,
      StreamLoadingSpinnerSize.sm => 20.0,
      StreamLoadingSpinnerSize.xs => 16.0,
    };

    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: XPProgressBar(
        value: props.value,
        width: dimension * 2.5,
        height: math.max(dimension / 2, 8),
      ),
    );
  }
}
