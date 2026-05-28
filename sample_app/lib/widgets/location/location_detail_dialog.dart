import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/widgets/location/location_user_marker.dart';
import 'package:sample_app/widgets/simple_map_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<T?> showLocationDetailDialog<T extends Object?>({
  required BuildContext context,
  required Location location,
}) async {
  final navigator = Navigator.of(context);
  return navigator.push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => StreamChannel(
        channel: StreamChannel.of(context).channel,
        child: LocationDetailDialog(sharedLocation: location),
      ),
    ),
  );
}

Stream<Message?> _findLocationMessageStream(
  Channel channel,
  Location location,
) {
  final messageId = location.messageId;
  if (messageId == null) return Stream.value(null);

  final channelState = channel.state;
  if (channelState == null) return Stream.value(null);

  return channelState.messagesStream.map((messages) {
    return messages.firstWhereOrNull((message) => message.id == messageId);
  });
}

class LocationDetailDialog extends StatelessWidget {
  const LocationDetailDialog({
    super.key,
    required this.sharedLocation,
  });

  final Location sharedLocation;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final locationStream = _findLocationMessageStream(channel, sharedLocation);

    return Scaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Shared Location')),
      body: BetterStreamBuilder(
        stream: locationStream,
        errorBuilder: (_, __) => const Center(child: LocationNotFound()),
        noDataBuilder: (_) => const Center(child: CircularProgressIndicator()),
        builder: (context, message) {
          final sharedLocation = message.sharedLocation;
          if (sharedLocation == null) {
            return const Center(child: LocationNotFound());
          }

          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SimpleMapView(
                cameraZoom: 16,
                markerSize: MarkerSize.xl,
                coordinates: sharedLocation.coordinates,
                markerBuilder: (_, __, size) => LocationUserMarker(
                  user: message.user,
                  size: size,
                  sharedLocation: sharedLocation,
                ),
              ),
              if (sharedLocation.isLive)
                LocationDetailBottomSheet(
                  sharedLocation: sharedLocation,
                  onStopSharingPressed: () {
                    final client = StreamChat.of(context).client;

                    final messageId = sharedLocation.messageId;
                    if (messageId == null) return;

                    client.stopLiveLocation(
                      messageId: messageId,
                      createdByDeviceId: sharedLocation.createdByDeviceId,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class LocationNotFound extends StatelessWidget {
  const LocationNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          size: 48,
          Icons.near_me_disabled_rounded,
          color: context.streamColorScheme.accentError,
        ),
        Text(
          'Location not found',
          style: context.streamTextTheme.headingMd.copyWith(
            color: context.streamColorScheme.textPrimary,
          ),
        ),
        Text(
          'The location you are looking for is not available.',
          style: context.streamTextTheme.bodyDefault.copyWith(
            color: context.streamColorScheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class LocationDetailBottomSheet extends StatelessWidget {
  const LocationDetailBottomSheet({
    super.key,
    required this.sharedLocation,
    this.onStopSharingPressed,
  });

  final Location sharedLocation;
  final VoidCallback? onStopSharingPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.streamColorScheme.backgroundElevation1,
      borderRadius: const BorderRadiusDirectional.only(
        topEnd: Radius.circular(14),
        topStart: Radius.circular(14),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: LocationDetail(
          sharedLocation: sharedLocation,
          onStopSharingPressed: onStopSharingPressed,
        ),
      ),
    );
  }
}

class LocationDetail extends StatelessWidget {
  const LocationDetail({
    super.key,
    required this.sharedLocation,
    this.onStopSharingPressed,
  });

  final Location sharedLocation;
  final VoidCallback? onStopSharingPressed;

  @override
  Widget build(BuildContext context) {
    assert(
      sharedLocation.isLive,
      'Footer should only be shown for live locations',
    );

    final updatedAt = sharedLocation.updatedAt;
    final sharingEndAt = sharedLocation.endAt!;
    const maximumButtonSize = Size(double.infinity, 40);

    if (sharingEndAt.isBefore(DateTime.now())) {
      final jiffyUpdatedAt = Jiffy.parseFromDateTime(updatedAt.toLocal());

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.fromSize(
            size: maximumButtonSize,
            child: Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.near_me_disabled_rounded,
                  color: context.streamColorScheme.accentError,
                ),
                Text(
                  'Live location ended',
                  style: context.streamTextTheme.headingMd.copyWith(
                    color: context.streamColorScheme.accentError,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Location last updated at ${jiffyUpdatedAt.jm}',
            style: context.streamTextTheme.bodyDefault.copyWith(
              color: context.streamColorScheme.textSecondary,
            ),
          ),
        ],
      );
    }

    final sharedLocationUserId = sharedLocation.userId;
    final currentUserId = StreamChat.of(context).currentUser?.id;

    // If the shared location is not shared by the current user, show the
    // "Live until" duration text.
    if (sharedLocationUserId != currentUserId) {
      final jiffySharingEndAt = Jiffy.parseFromDateTime(sharingEndAt.toLocal());

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.fromSize(
            size: maximumButtonSize,
            child: Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.near_me_rounded,
                  color: context.streamColorScheme.accentPrimary,
                ),
                Text(
                  'Live Location',
                  style: context.streamTextTheme.headingMd.copyWith(
                    color: context.streamColorScheme.accentPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Live until ${jiffySharingEndAt.jm}',
            style: context.streamTextTheme.bodyDefault.copyWith(
              color: context.streamColorScheme.textSecondary,
            ),
          ),
        ],
      );
    }

    // Otherwise, show the "Stop Sharing" button.
    final buttonStyle = TextButton.styleFrom(
      maximumSize: maximumButtonSize,
      textStyle: context.streamTextTheme.headingMd,
      visualDensity: VisualDensity.compact,
      foregroundColor: context.streamColorScheme.accentError,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );

    final jiffySharingEndAt = Jiffy.parseFromDateTime(sharingEndAt.toLocal());

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: TextButton.icon(
            style: buttonStyle,
            onPressed: onStopSharingPressed,
            icon: Icon(
              Icons.near_me_disabled_rounded,
              color: context.streamColorScheme.accentError,
            ),
            label: const Text('Stop Sharing'),
          ),
        ),
        Center(
          child: Text(
            'Live until ${jiffySharingEndAt.jm}',
            style: context.streamTextTheme.bodyDefault.copyWith(
              color: context.streamColorScheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
