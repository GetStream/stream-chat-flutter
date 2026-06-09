import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/utils/location_provider.dart';
import 'package:sample_app/widgets/location/location_user_marker.dart';
import 'package:sample_app/widgets/simple_map_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class LocationPickerResult {
  const LocationPickerResult({
    this.endSharingAt,
    required this.coordinates,
  });

  final DateTime? endSharingAt;
  final LocationCoordinates coordinates;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationPickerResult &&
        runtimeType == other.runtimeType &&
        endSharingAt == other.endSharingAt &&
        coordinates == other.coordinates;
  }

  @override
  int get hashCode => endSharingAt.hashCode ^ coordinates.hashCode;
}

Future<T?> showLocationPickerDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  EdgeInsets padding = const EdgeInsets.all(16),
  TraversalEdgeBehavior? traversalEdgeBehavior,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(
    MaterialPageRoute(
      fullscreenDialog: true,
      barrierDismissible: barrierDismissible,
      builder: (context) => const LocationPickerDialog(),
    ),
  );
}

class LocationPickerDialog extends StatefulWidget {
  const LocationPickerDialog({super.key});

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> with WidgetsBindingObserver {
  LocationCoordinates? _currentLocation;

  /// After opening app settings, reload location when the user returns.
  bool _retryLocationAfterResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _retryLocationAfterResume) {
      setState(() => _retryLocationAfterResume = false);
    }
  }

  Future<void> _openAppSettingsForPermission() async {
    setState(() => _retryLocationAfterResume = true);

    final wasOpened = await LocationProvider().openLocationSettings();
    // If we couldn't open location settings, try opening app settings as a fallback.
    if (!wasOpened) await LocationProvider().openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Share Location')),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          FutureBuilder(
            future: LocationProvider().getCurrentLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              final position = snapshot.data;
              if (snapshot.hasError || position == null) {
                return Center(child: LocationNotFound(onOpenAppSettings: _openAppSettingsForPermission));
              }

              final coordinates = _currentLocation = LocationCoordinates(
                latitude: position.latitude,
                longitude: position.longitude,
              );

              return SimpleMapView(
                cameraZoom: 18,
                markerSize: MarkerSize.sm,
                coordinates: coordinates,
                markerBuilder: (context, _, size) => AvatarGlow(
                  glowColor: colorScheme.accentPrimary,
                  child: Material(
                    elevation: 2,
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 4,
                        color: colorScheme.backgroundElevation1,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: size.value / 2,
                      backgroundColor: colorScheme.accentPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
          // Location picker options
          LocationPickerOptionList(
            onOptionSelected: (option) {
              final currentLocation = _currentLocation;
              if (currentLocation == null) return Navigator.pop(context);

              final result = LocationPickerResult(
                endSharingAt: switch (option) {
                  ShareStaticLocation() => null,
                  ShareLiveLocation() => option.endSharingAt,
                },
                coordinates: currentLocation,
              );

              return Navigator.pop(context, result);
            },
          ),
        ],
      ),
    );
  }
}

class LocationNotFound extends StatelessWidget {
  const LocationNotFound({
    super.key,
    required this.onOpenAppSettings,
  });

  final VoidCallback onOpenAppSettings;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            size: 32,
            context.streamIcons.location,
            color: colorScheme.textTertiary,
          ),
          SizedBox(height: spacing.xs),
          Text(
            'Please enable location access in Settings so you can share your position.',
            style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.md),
          StreamButton(
            type: .outline,
            style: .secondary,
            onPressed: onOpenAppSettings,
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

class LocationPickerOptionList extends StatelessWidget {
  const LocationPickerOptionList({
    super.key,
    required this.onOptionSelected,
  });

  final ValueSetter<LocationPickerOption> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.streamColorScheme.backgroundElevation1,
      borderRadius: const BorderRadiusDirectional.only(
        topEnd: Radius.circular(14),
        topStart: Radius.circular(14),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 14,
          ),
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              LocationPickerOptionItem(
                icon: const Icon(Icons.share_location_rounded),
                title: 'Share Live Location',
                subtitle: 'Your location will update in real-time',
                onTap: () async {
                  final duration = await showCupertinoModalPopup<Duration>(
                    context: context,
                    builder: (_) => const LiveLocationDurationDialog(),
                  );

                  if (duration == null) return;
                  final endSharingAt = DateTime.timestamp().add(duration);

                  return onOptionSelected(
                    ShareLiveLocation(endSharingAt: endSharingAt),
                  );
                },
              ),
              LocationPickerOptionItem(
                icon: const Icon(Icons.my_location),
                title: 'Share Static Location',
                subtitle: 'Send your current location only',
                onTap: () => onOptionSelected(const ShareStaticLocation()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

sealed class LocationPickerOption {
  const LocationPickerOption();
}

final class ShareLiveLocation extends LocationPickerOption {
  const ShareLiveLocation({required this.endSharingAt});
  final DateTime endSharingAt;
}

final class ShareStaticLocation extends LocationPickerOption {
  const ShareStaticLocation();
}

class LocationPickerOptionItem extends StatelessWidget {
  const LocationPickerOptionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.backgroundElevation1,
        foregroundColor: colorScheme.accentPrimary,
        side: BorderSide(color: colorScheme.borderDefault, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          size: 24,
          color: colorScheme.accentPrimary,
        ),
        child: Row(
          spacing: 16,
          children: [
            icon,
            Expanded(
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyEmphasis.copyWith(
                      color: colorScheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.captionDefault.copyWith(
                      color: colorScheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              context.streamIcons.chevronRight,
              size: 24,
              color: colorScheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class LiveLocationDurationDialog extends StatelessWidget {
  const LiveLocationDurationDialog({super.key});

  static const _endAtDurations = [
    Duration(minutes: 15),
    Duration(hours: 1),
    Duration(hours: 8),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(
        primaryColor: colorScheme.accentPrimary,
      ),
      child: CupertinoActionSheet(
        title: const Text('Share Live Location'),
        message: Text(
          'Select the duration for sharing your live location.',
          style: context.streamTextTheme.captionDefault.copyWith(
            color: colorScheme.textSecondary,
          ),
        ),
        actions: [
          ..._endAtDurations.map((duration) {
            final endAt = Jiffy.now().addDuration(duration);
            return CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(duration),
              child: Text(endAt.fromNow(withPrefixAndSuffix: false)),
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
