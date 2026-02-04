import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/utils/location_provider.dart';
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

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  LocationCoordinates? _currentLocation;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return Scaffold(
      backgroundColor: colorTheme.appBg,
      appBar: AppBar(
        backgroundColor: colorTheme.barsBg,
        title: const Text('Share Location'),
      ),
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
                return const Center(child: LocationNotFound());
              }

              final coordinates = _currentLocation = LocationCoordinates(
                latitude: position.latitude,
                longitude: position.longitude,
              );

              return SimpleMapView(
                cameraZoom: 18,
                markerSize: 24,
                coordinates: coordinates,
                markerBuilder: (context, _, size) => AvatarGlow(
                  glowColor: colorTheme.accentPrimary,
                  child: Material(
                    elevation: 2,
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 4,
                        color: colorTheme.barsBg,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: size / 2,
                      backgroundColor: colorTheme.accentPrimary,
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
  const LocationNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final colorTheme = chatThemeData.colorTheme;
    final textTheme = chatThemeData.textTheme;

    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          size: 48,
          Icons.near_me_disabled_rounded,
          color: colorTheme.accentError,
        ),
        Text(
          'Something went wrong',
          style: textTheme.headline.copyWith(
            color: colorTheme.textHighEmphasis,
          ),
        ),
        Text(
          'Please check your location settings and try again.',
          style: textTheme.body.copyWith(
            color: colorTheme.textLowEmphasis,
          ),
        ),
      ],
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
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return Material(
      color: colorTheme.barsBg,
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
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: colorTheme.barsBg,
        foregroundColor: colorTheme.accentPrimary,
        side: BorderSide(color: colorTheme.borders, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
      child: IconTheme(
        data: IconTheme.of(context).copyWith(
          size: 24,
          color: colorTheme.accentPrimary,
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
                    style: textTheme.bodyBold.copyWith(
                      color: colorTheme.textHighEmphasis,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: textTheme.footnote.copyWith(
                      color: colorTheme.textLowEmphasis,
                    ),
                  ),
                ],
              ),
            ),
            StreamSvgIcon(
              size: 24,
              icon: StreamSvgIcons.right,
              color: colorTheme.textLowEmphasis,
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
    final theme = StreamChatTheme.of(context);

    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(
        primaryColor: theme.colorTheme.accentPrimary,
      ),
      child: CupertinoActionSheet(
        title: const Text('Share Live Location'),
        message: Text(
          'Select the duration for sharing your live location.',
          style: theme.textTheme.footnote.copyWith(
            color: theme.colorTheme.textLowEmphasis,
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
