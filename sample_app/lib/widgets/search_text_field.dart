// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = 'Search',
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return Padding(
      padding: .directional(
        start: spacing.md,
        end: spacing.md,
        top: spacing.md,
        bottom: spacing.xs,
      ),
      child: StreamTextInput(
        hintText: hintText,
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: .center,
        leading: Icon(context.streamIcons.search),
        style: StreamTextInputStyle(
          borderRadius: .all(radius.max),
          focusBorder: BorderSide(color: colorScheme.borderDefault),
        ),
      ),
    );
  }
}
