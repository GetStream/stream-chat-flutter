import 'package:flutter/material.dart';

class TranslucentScaffold extends StatelessWidget {
  const TranslucentScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  final Widget? body;
  final Widget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    const background = Color(0xff0A070B);
    return Stack(
      children: [
        const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ColoredBox(
            color: background,
          ),
        ),
        Positioned(
          right: -185.5,
          top: 33,
          child: Opacity(
            opacity: .09,
            child: Container(
              height: 371,
              width: 371,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  stops: const [.23, 1],
                  colors: [
                    const Color(0xffFF9024).withOpacity(.8),
                    background,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: -185.5,
          top: 198,
          child: Opacity(
            opacity: .12,
            child: Container(
              height: 371,
              width: 371,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  stops: [.23, 1],
                  colors: [
                    Color(0xff0364F6),
                    background,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -100,
          child: Opacity(
            opacity: .10,
            child: Container(
              height: 371,
              width: 371,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  stops: [.23, 1],
                  colors: [
                    Color(0xff11D6BE),
                    background,
                  ],
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: body,
          appBar: appBar != null
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: appBar!,
                )
              : null,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}
