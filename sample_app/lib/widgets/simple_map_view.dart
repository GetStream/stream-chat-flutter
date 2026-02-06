import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:sample_app/widgets/location/location_user_marker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

typedef MarkerBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      MarkerSize markerSize,
    );

class SimpleMapView extends StatefulWidget {
  const SimpleMapView({
    super.key,
    this.cameraZoom = 15,
    this.markerSize = MarkerSize.lg,
    required this.coordinates,
    this.showLocateMeButton = true,
    this.markerBuilder = _defaultMarkerBuilder,
  });

  final double cameraZoom;

  final MarkerSize markerSize;

  final LocationCoordinates coordinates;

  final bool showLocateMeButton;

  final MarkerBuilder markerBuilder;
  static Widget _defaultMarkerBuilder(BuildContext context, _, MarkerSize size) {
    final theme = StreamChatTheme.of(context);
    final iconColor = theme.colorTheme.accentPrimary;
    return Icon(size: size.value, Icons.person_pin, color: iconColor);
  }

  @override
  State<SimpleMapView> createState() => _SimpleMapViewState();
}

class _SimpleMapViewState extends State<SimpleMapView> with TickerProviderStateMixin<SimpleMapView> {
  late final _mapController = AnimatedMapController(vsync: this);
  late final _initialCenter = widget.coordinates.toLatLng();

  @override
  void didUpdateWidget(covariant SimpleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinates != widget.coordinates) {
      _mapController.animateTo(
        dest: widget.coordinates.toLatLng(),
        zoom: widget.cameraZoom,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    const baseMapTemplate = 'https://{s}.basemaps.cartocdn.com';
    const mapTemplate = '$baseMapTemplate/rastertiles/voyager/{z}/{x}/{y}.png';
    const fallbackTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    return FlutterMap(
      mapController: _mapController.mapController,
      options: MapOptions(
        keepAlive: true,
        initialCenter: _initialCenter,
        initialZoom: widget.cameraZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: mapTemplate,
          fallbackUrl: fallbackTemplate,
          tileBuilder: (context, tile, __) => switch (brightness) {
            Brightness.light => tile,
            Brightness.dark => darkModeTilesContainerBuilder(context, tile),
          },
          userAgentPackageName: switch (CurrentPlatform.type) {
            PlatformType.ios => 'io.getstream.flutter',
            PlatformType.android => 'io.getstream.chat.android.flutter.sample',
            _ => 'unknown',
          },
        ),
        AnimatedMarkerLayer(
          markers: [
            AnimatedMarker(
              height: widget.markerSize.value,
              width: widget.markerSize.value,
              point: widget.coordinates.toLatLng(),
              builder: (context, animation) => widget.markerBuilder(
                context,
                animation,
                widget.markerSize,
              ),
            ),
          ],
        ),
        if (widget.showLocateMeButton)
          SimpleMapLocateMeButton(
            onPressed: () => _mapController.animateTo(
              zoom: widget.cameraZoom,
              curve: Curves.easeInOut,
              dest: widget.coordinates.toLatLng(),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

class SimpleMapLocateMeButton extends StatelessWidget {
  const SimpleMapLocateMeButton({
    super.key,
    this.onPressed,
    this.alignment = AlignmentDirectional.topEnd,
  });

  final AlignmentGeometry alignment;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton.small(
          onPressed: onPressed,
          shape: const CircleBorder(),
          foregroundColor: colorTheme.accentPrimary,
          backgroundColor: colorTheme.barsBg,
          child: const Icon(Icons.near_me_rounded),
        ),
      ),
    );
  }
}

extension on LocationCoordinates {
  LatLng toLatLng() => LatLng(latitude, longitude);
}
