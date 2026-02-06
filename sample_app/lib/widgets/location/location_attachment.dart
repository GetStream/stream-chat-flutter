import 'package:flutter/material.dart';
import 'package:sample_app/widgets/location/location_user_marker.dart';
import 'package:sample_app/widgets/simple_map_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _defaultLocationConstraints = BoxConstraints(
  maxWidth: 270,
  maxHeight: 180,
);

/// {@template locationAttachmentBuilder}
/// A builder for creating a location attachment widget.
/// {@endtemplate}
class LocationAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro locationAttachmentBuilder}
  const LocationAttachmentBuilder({
    this.constraints = _defaultLocationConstraints,
    this.padding = const EdgeInsets.all(4),
    this.onAttachmentTap,
  });

  /// The constraints to apply to the file attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the file attachment widget.
  final EdgeInsetsGeometry padding;

  /// Optional callback to handle tap events on the attachment.
  final ValueSetter<Location>? onAttachmentTap;

  @override
  bool canHandle(Message message, _) => message.sharedLocation != null;

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final user = message.user;
    final location = message.sharedLocation!;
    return LocationAttachment(
      user: user,
      sharedLocation: location,
      constraints: constraints,
      padding: padding,
      onLocationTap: switch (onAttachmentTap) {
        final onTap? => () => onTap(location),
        _ => null,
      },
    );
  }
}

/// Displays a location attachment with a map view and optional footer.
class LocationAttachment extends StatelessWidget {
  /// Creates a new [LocationAttachment].
  const LocationAttachment({
    super.key,
    required this.user,
    required this.sharedLocation,
    this.constraints = _defaultLocationConstraints,
    this.padding = const EdgeInsets.all(2),
    this.onLocationTap,
  });

  /// The user who shared the location.
  final User? user;

  /// The shared location data.
  final Location sharedLocation;

  /// The constraints to apply to the file attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the file attachment widget.
  final EdgeInsetsGeometry padding;

  /// Optional callback to handle tap events on the location attachment.
  final VoidCallback? onLocationTap;

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.of(context).currentUser;
    final sharedLocationEndAt = sharedLocation.endAt;

    return Padding(
      padding: padding,
      child: ConstrainedBox(
        constraints: constraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Material(
                clipBehavior: Clip.antiAlias,
                type: MaterialType.transparency,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: onLocationTap,
                  child: IgnorePointer(
                    child: SimpleMapView(
                      markerSize: MarkerSize.lg,
                      showLocateMeButton: false,
                      coordinates: sharedLocation.coordinates,
                      markerBuilder: (_, __, size) => LocationUserMarker(
                        user: user,
                        size: size,
                        sharedLocation: sharedLocation,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (sharedLocationEndAt != null && currentUser != null)
              LocationAttachmentFooter(
                currentUser: currentUser,
                sharingEndAt: sharedLocationEndAt,
                sharedLocation: sharedLocation,
                onStopSharingPressed: () {
                  final client = StreamChat.of(context).client;

                  final location = sharedLocation;
                  final messageId = location.messageId;
                  if (messageId == null) return;

                  client.stopLiveLocation(
                    messageId: messageId,
                    createdByDeviceId: location.createdByDeviceId,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class LocationAttachmentFooter extends StatelessWidget {
  const LocationAttachmentFooter({
    super.key,
    required this.currentUser,
    required this.sharingEndAt,
    required this.sharedLocation,
    this.onStopSharingPressed,
  });

  final User currentUser;
  final DateTime sharingEndAt;
  final Location sharedLocation;
  final VoidCallback? onStopSharingPressed;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    const maximumSize = Size(double.infinity, 40);

    // If the location sharing has ended, show a message indicating that.
    if (sharingEndAt.isBefore(DateTime.now())) {
      return SizedBox.fromSize(
        size: maximumSize,
        child: Row(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.near_me_disabled_rounded,
              color: colorTheme.textLowEmphasis,
            ),
            Text(
              'Live location ended',
              style: textTheme.bodyBold.copyWith(
                color: colorTheme.textLowEmphasis,
              ),
            ),
          ],
        ),
      );
    }

    final currentUserId = currentUser.id;
    final sharedLocationUserId = sharedLocation.userId;

    // If the shared location is not shared by the current user, show the
    // "Live until" duration text.
    if (sharedLocationUserId != currentUserId) {
      final liveUntil = Jiffy.parseFromDateTime(sharingEndAt.toLocal());

      return SizedBox.fromSize(
        size: maximumSize,
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
              'Live until ${liveUntil.jm}',
              style: textTheme.bodyBold.copyWith(
                color: colorTheme.accentPrimary,
              ),
            ),
          ],
        ),
      );
    }

    // Otherwise, show the "Stop Sharing" button.
    final buttonStyle = TextButton.styleFrom(
      maximumSize: maximumSize,
      textStyle: textTheme.bodyBold,
      visualDensity: VisualDensity.compact,
      foregroundColor: colorTheme.accentError,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );

    return TextButton.icon(
      style: buttonStyle,
      onPressed: onStopSharingPressed,
      icon: Icon(
        Icons.near_me_disabled_rounded,
        color: colorTheme.accentError,
      ),
      label: const Text('Stop Sharing'),
    );
  }
}
