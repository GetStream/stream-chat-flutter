import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class StreamChannelListLoadingTile extends StatelessWidget {
  const StreamChannelListLoadingTile({
    Key? key,
    this.visualDensity = VisualDensity.standard,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
  }) : super(key: key);

  /// Defines how compact the list tile's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  final VisualDensity visualDensity;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;

    final leading = Container(
      height: 49,
      width: 49,
      decoration: BoxDecoration(
        color: colorTheme.barsBg,
        shape: BoxShape.circle,
      ),
    );

    final title = Container(
      height: 16,
      width: 66,
      decoration: BoxDecoration(
        color: colorTheme.barsBg,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final subtitle = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: colorTheme.barsBg,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 16,
          width: 50,
          decoration: BoxDecoration(
            color: colorTheme.barsBg,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );

    return Shimmer.fromColors(
      baseColor: colorTheme.disabled,
      highlightColor: colorTheme.inputBg,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        visualDensity: visualDensity,
        contentPadding: contentPadding,
      ),
    );
  }
}
