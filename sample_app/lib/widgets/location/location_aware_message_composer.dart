import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_app/config/sample_app_config.dart';
import 'package:sample_app/widgets/location/location_picker_dialog.dart';
import 'package:sample_app/widgets/location/location_picker_option.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Builds the composer, adding the location picker when location sharing is
/// available on the surrounding channel.
///
/// Registered as the `messageComposer` component builder rather than passed to a
/// composer directly, because [StreamChannelPage] and [StreamThreadPage] own
/// their composers and expose no parameters for them. Going through the
/// component factory reaches them anyway.
Widget locationAwareMessageComposer(BuildContext context, MessageComposerProps props) {
  // Null when a composer is built outside a channel; the factory is global, so
  // this builder must tolerate that rather than assume a channel ancestor.
  final channel = StreamChannel.maybeOf(context)?.channel;

  final locationEnabled =
      channel != null &&
      context.sampleAppConfig.enableLocationSharing &&
      channel.config?.sharedLocations == true &&
      channel.canShareLocation;

  if (!locationEnabled) return DefaultStreamMessageComposer(props: props);

  return DefaultStreamMessageComposer(
    props: props.copyWith(
      allowedAttachmentPickerTypes: [
        ...AttachmentPickerType.values,
        const LocationPickerType(),
      ],
      onAttachmentPickerResult: (result) => _onCustomAttachmentPickerResult(channel, result),
      attachmentPickerOptionsBuilder: (context, defaultOptions) => [
        ...defaultOptions,
        TabbedAttachmentPickerOption(
          key: 'location-picker',
          title: 'Location',
          icon: context.streamIcons.location,
          supportedTypes: [const LocationPickerType()],
          isEnabled: (value) {
            if (value.isEmpty) return true;
            return value.extraData['location'] != null;
          },
          optionViewBuilder: (context, controller) => LocationPicker(
            onLocationPicked: (locationResult) {
              if (locationResult == null) return;

              controller.notifyCustomResult(
                LocationPicked(location: locationResult),
              );
            },
          ),
        ),
      ],
    ),
  );
}

bool _onCustomAttachmentPickerResult(
  Channel channel,
  StreamAttachmentPickerResult result,
) {
  if (result is LocationPicked) {
    _onShareLocationPicked(channel, result.location).ignore();
    return true; // Notify that the result was handled.
  }

  return false; // Notify that the result was not handled.
}

Future<SendMessageResponse> _onShareLocationPicked(
  Channel channel,
  LocationPickerResult result,
) async {
  if (result.endSharingAt case final endSharingAt?) {
    return channel.startLiveLocationSharing(
      endSharingAt: endSharingAt,
      location: result.coordinates,
    );
  }

  return channel.sendStaticLocation(location: result.coordinates);
}
