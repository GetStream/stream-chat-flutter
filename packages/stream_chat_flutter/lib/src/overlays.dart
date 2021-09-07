import 'package:flutter/material.dart';

/// Class to create an overlay anchored to a child widget
class AnchoredOverlay extends StatelessWidget {
  /// Constructor for creating an [AnchoredOverlay]
  const AnchoredOverlay({
    Key? key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);

  /// Show or hide overlay
  final bool showOverlay;

  /// Builder for creating overlay widget
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;

  /// Child to which overlay is anchored
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                OverlayBuilder(
                  showOverlay: showOverlay,
                  overlayBuilder: (BuildContext overlayContext) {
                    final box = context.findRenderObject() as RenderBox?;
                    if (box != null) {
                      final center = box.size
                          .center(box.localToGlobal(const Offset(0, 0)));
                      return overlayBuilder(overlayContext, center);
                    } else {
                      return const SizedBox();
                    }
                  },
                  child: child,
                )),
      );
}

/// Class for creating a declarative-ish overlay
class OverlayBuilder extends StatefulWidget {
  /// Constructor for creating an [OverlayBuilder]
  const OverlayBuilder({
    Key? key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);

  /// Show or hide overlay
  final bool showOverlay;

  /// Builder for creating overlay widget
  final Widget Function(BuildContext) overlayBuilder;

  /// Child to which overlay is anchored
  final Widget child;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
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
  Widget build(BuildContext context) => widget.child;
}

/// Class to position Overlay
class CenterAbout extends StatelessWidget {
  /// Constructor for creating an [CenterAbout]
  const CenterAbout({
    Key? key,
    required this.position,
    required this.child,
  }) : super(key: key);

  /// Position of child
  final Offset position;

  /// Child widget to which overlay is attached
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      bottom: size.height - position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: child,
        ),
      ),
    );
  }
}
