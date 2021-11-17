import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// List tile for [ChannelBottomSheet]
class OptionListTile extends StatelessWidget {
  /// Constructor for creating [OptionListTile]
  const OptionListTile({
    Key? key,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.tileColor,
    this.separatorColor,
    this.titleTextStyle,
  }) : super(key: key);

  /// Title for tile
  final String title;

  /// Leading widget (start)
  final Widget? leading;

  /// Trailing widget (end)
  final Widget? trailing;

  /// Callback when tile is tapped
  final VoidCallback? onTap;

  /// Title color
  final Color? titleColor;

  /// Background tile color
  final Color? tileColor;

  /// Separator color
  final Color? separatorColor;

  /// [TextStyle] to apply to [title]
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return Column(
      children: [
        Container(
          height: 1,
          color: separatorColor ?? chatThemeData.colorTheme.disabled,
        ),
        Material(
          color: tileColor ?? chatThemeData.colorTheme.barsBg,
          child: SizedBox(
            height: 63,
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  if (leading != null)
                    Center(child: leading)
                  else
                    const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Text(
                      title,
                      style: titleTextStyle ??
                          (titleColor == null
                              ? chatThemeData.textTheme.bodyBold
                              : chatThemeData.textTheme.bodyBold.copyWith(
                                  color: titleColor,
                                )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
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
