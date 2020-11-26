import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback onTap;
  final bool showCloseButton;

  const SearchTextField({
    Key key,
    @required this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = 'Search',
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
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
                prefixIconConstraints: BoxConstraints.tight(Size(40, 24)),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: StreamSvgIcon.search(
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.all(0),
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
                padding: const EdgeInsets.all(0),
                icon: StreamSvgIcon.close_small(
                  color: Colors.grey,
                ),
                splashRadius: 24,
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    Future.microtask(
                      () => [
                        controller.clear(),
                        onChanged(''),
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
