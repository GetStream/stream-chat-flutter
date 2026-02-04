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
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    final channel = StreamChannel.of(context).channel;
    final locationStream = _findLocationMessageStream(channel, sharedLocation);

    return Scaffold(
      backgroundColor: colorTheme.appBg,
      appBar: AppBar(
        backgroundColor: colorTheme.barsBg,
        title: const Text('Shared Location'),
      ),
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
                markerSize: 48,
                coordinates: sharedLocation.coordinates,
                markerBuilder: (_, __, size) => LocationUserMarker(
                  user: message.user,
                  markerSize: size,
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
          'Location not found',
          style: textTheme.headline.copyWith(
            color: colorTheme.textHighEmphasis,
          ),
        ),
        Text(
          'The location you are looking for is not available.',
          style: textTheme.body.copyWith(
            color: colorTheme.textLowEmphasis,
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
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return Material(
      color: colorTheme.barsBg,
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

    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

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
                  color: colorTheme.accentError,
                ),
                Text(
                  'Live location ended',
                  style: textTheme.headlineBold.copyWith(
                    color: colorTheme.accentError,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Location last updated at ${jiffyUpdatedAt.jm}',
            style: textTheme.body.copyWith(
              color: colorTheme.textLowEmphasis,
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
                  color: colorTheme.accentPrimary,
                ),
                Text(
                  'Live Location',
                  style: textTheme.headlineBold.copyWith(
                    color: colorTheme.accentPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Live until ${jiffySharingEndAt.jm}',
            style: textTheme.body.copyWith(
              color: colorTheme.textLowEmphasis,
            ),
          ),
        ],
      );
    }

    // Otherwise, show the "Stop Sharing" button.
    final buttonStyle = TextButton.styleFrom(
      maximumSize: maximumButtonSize,
      textStyle: textTheme.headlineBold,
      visualDensity: VisualDensity.compact,
      foregroundColor: colorTheme.accentError,
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
              color: colorTheme.accentError,
            ),
            label: const Text('Stop Sharing'),
          ),
        ),
        Center(
          child: Text(
            'Live until ${jiffySharingEndAt.jm}',
            style: textTheme.body.copyWith(
              color: colorTheme.textLowEmphasis,
            ),
          ),
        ),
      ],
    );
  }
}
