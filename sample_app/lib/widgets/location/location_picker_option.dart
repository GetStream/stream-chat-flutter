import 'package:flutter/material.dart';
import 'package:sample_app/widgets/location/location_picker_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final class LocationPickerType extends CustomAttachmentPickerType {
  const LocationPickerType();
}

final class LocationPicked extends CustomAttachmentPickerResult {
  const LocationPicked({required this.location});
  final LocationPickerResult location;
}

class LocationPicker extends StatelessWidget {
  const LocationPicker({
    super.key,
    this.onLocationPicked,
  });

  final ValueSetter<LocationPickerResult?>? onLocationPicked;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    Future<void> openLocationPicker() async {
      final result = await runInPermissionRequestLock(() {
        return showLocationPickerDialog(context: context);
      });

      onLocationPicked?.call(result);
    }

    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 32,
                context.streamIcons.location,
                color: colorScheme.textTertiary,
              ),
              SizedBox(height: spacing.xs),
              Text(
                'Share your location on the map and choose how to send it.',
                style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.md),
              StreamButton(
                type: .outline,
                style: .secondary,
                onPressed: openLocationPicker,
                child: const Text('Open location'),
              ),
            ],
          ),
        ),
        onEndOfFrame: (_) => openLocationPicker(),
      ),
    );
  }
}
