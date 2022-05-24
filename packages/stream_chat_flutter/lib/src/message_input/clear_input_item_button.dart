// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template clearInputItemButton}
/// Used to clear items from the [MessageInput] field, such as attachments
/// or message quotes.
/// {@endtemplate}
class ClearInputItemButton extends StatelessWidget {
  /// {@macro clearInputItemButton}
  const ClearInputItemButton({
    super.key,
    required this.onTap,
  });

  /// The callback to be performed when the button is tapped or clicked.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    return SizedBox(
      height: 20,
      width: 20,
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        onPressed: onTap,
        fillColor:
            _streamChatTheme.colorTheme.textHighEmphasis.withOpacity(0.5),
        child: Center(
          child: StreamSvgIcon.close(
            size: 24,
            color: _streamChatTheme.colorTheme.barsBg,
          ),
        ),
      ),
    );
  }
}
