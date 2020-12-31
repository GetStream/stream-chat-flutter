import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';

class OptionListTile extends StatelessWidget {
  final String title;
  final StreamSvgIcon leading;
  final Widget trailing;
  final VoidCallback onTap;
  final Color titleColor;

  OptionListTile({
    this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xffe6e6e6),
          height: 2.0,
        ),
        Material(
          color: Colors.white,
          child: Container(
            height: 56.0,
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  if (leading != null)
                    Expanded(
                      child: Center(child: leading),
                    ),
                  if (leading == null)
                    SizedBox(
                      width: 16.0,
                    ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: trailing ?? Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
