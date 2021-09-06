import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return new OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (BuildContext overlayContext) {
            RenderBox box = context.findRenderObject() as RenderBox;
            final center =
                box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
            return overlayBuilder(overlayContext, center);
          },
          child: child,
        );
      }),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  OverlayBuilder({
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });

  @override
  _OverlayBuilderState createState() => new _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder,
    );
    if (overlayEntry != null) {
      addToOverlay(overlayEntry!);
    }
  }

  void addToOverlay(OverlayEntry entry) async {
    print('addToOverlay');
    Overlay.of(context)?.insert(entry);
  }

  void hideOverlay() {
    print('hideOverlay');
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  final Offset position;
  final Widget child;

  CenterAbout({
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Positioned(
      bottom: size.height - position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: child,
        ),
      ),
    );
  }
}
