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
    this.showCloseButton = true,
  });
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onTap;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: colorScheme.borderDefault,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.only(
        top: spacing.md,
        bottom: spacing.xs,
        left: spacing.md,
        right: spacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onTap: onTap,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints.tight(const Size(36, 24)),
                prefixIcon: Padding(
                  padding: .directional(start: spacing.md),
                  child: Icon(
                    context.streamIcons.search,
                    color: colorScheme.textTertiary,
                    size: 20,
                  ),
                ),
                hintText: hintText,
                hintStyle: textTheme.bodyDefault.copyWith(
                  color: colorScheme.textTertiary,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          if (showCloseButton)
            Material(
              color: Colors.transparent,
              child: IconButton(
                color: colorScheme.textTertiary,
                padding: EdgeInsets.zero,
                icon: Icon(context.streamIcons.xCircle, size: 20),
                splashRadius: 24,
                onPressed: () {
                  if (controller!.text.isNotEmpty) {
                    Future.microtask(
                      () => [
                        controller!.clear(),
                        if (onChanged != null) onChanged!(''),
                      ],
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
