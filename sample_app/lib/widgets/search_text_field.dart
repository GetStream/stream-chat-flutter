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
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: StreamChatTheme.of(context).colorTheme.barsBg,
        border: Border.all(
          color: StreamChatTheme.of(context).colorTheme.borders,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onTap: onTap,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixText: '    ',
                prefixIconConstraints: BoxConstraints.tight(const Size(40, 24)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: StreamSvgIcon(
                    icon: StreamSvgIcons.search,
                    color:
                        StreamChatTheme.of(context).colorTheme.textHighEmphasis,
                    size: 24,
                  ),
                ),
                hintText: hintText,
                hintStyle: StreamChatTheme.of(context).textTheme.body.copyWith(
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .textHighEmphasis
                        .withOpacity(.5)),
                contentPadding: EdgeInsets.zero,
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
                color: Colors.grey,
                padding: EdgeInsets.zero,
                icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
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
