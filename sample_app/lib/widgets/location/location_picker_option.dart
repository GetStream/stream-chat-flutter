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
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return OptionDrawer(
      child: EndOfFrameCallbackWidget(
        child: Icon(
          size: 148,
          Icons.near_me_rounded,
          color: colorTheme.disabled,
        ),
        onEndOfFrame: (context) async {
          final result = await runInPermissionRequestLock(() {
            return showLocationPickerDialog(context: context);
          });

          onLocationPicked?.call(result);
        },
        errorBuilder: (context, error, stacktrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 148,
                Icons.pin_drop_rounded,
                color: theme.colorTheme.disabled,
              ),
              Text(
                context.translations.enablePhotoAndVideoAccessMessage,
                style: theme.textTheme.body.copyWith(
                  color: theme.colorTheme.textLowEmphasis,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: null,
                child: Text(
                  context.translations.allowGalleryAccessMessage,
                  style: theme.textTheme.bodyBold.copyWith(
                    color: theme.colorTheme.accentPrimary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
