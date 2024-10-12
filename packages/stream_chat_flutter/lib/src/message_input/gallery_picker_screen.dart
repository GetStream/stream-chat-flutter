import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/message_input/gallery_picker_widget.dart';
import 'package:stream_chat_flutter/src/message_input/translucent_scafold.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

/// @author:Shashi
class GalleryPickerScreen extends StatefulWidget {
  const GalleryPickerScreen({super.key});

  @override
  State<GalleryPickerScreen> createState() => _GalleryPickerScreenState();
}

class _GalleryPickerScreenState extends State<GalleryPickerScreen> {
  StreamAttachmentPickerController attachmentController =
      StreamAttachmentPickerController();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white);
    return ValueListenableBuilder(
      valueListenable: attachmentController,
      builder: (context, value, child) {
        final selectedIds =
            attachmentController.value.map((it) => it.id).toList();
        return TranslucentScaffold(
          appBar: AppBar(
            title: const Text("Select your file"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Choose file from your folder",
                  style: textStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildOptions(context),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text("Select from your phone gallery",
                        style: textStyle),
                    const Spacer(),
                    Text("(${selectedIds.length}) Selected", style: textStyle),
                  ],
                ),
              ),
              Expanded(
                child: GalleryPickerWidget(
                  selectedMediaItems: selectedIds,
                  onMediaItemSelected: (AssetEntity media) async {
                    if (selectedIds.contains(media.id)) {
                      return await attachmentController
                          .removeAssetAttachment(media);
                    }
                    await attachmentController.addAssetAttachment(media);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            final pickedImage = await runInPermissionRequestLock(() {
              return StreamAttachmentHandler.instance.pickImage(
                source: image_picker.ImageSource.camera,
                preferredCameraDevice: image_picker.CameraDevice.rear,
              );
            });
            if (pickedImage != null) {
              await attachmentController.addAttachment(pickedImage);
            }
          },
          child: Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff1d1e25)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.teal,
                    size: 40,
                  ),
                  Text(
                    "Camera",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () async {
            final pickedFile = await StreamAttachmentHandler.instance.pickFile(
              dialogTitle: "Select file",
              allowCompression: true,
            );
            if (pickedFile != null) {
              await attachmentController.addAttachment(pickedFile);
            }
          },
          child: Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff1d1e25)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_copy_outlined,
                    color: Colors.teal,
                    size: 40,
                  ),
                  Text(
                    "File",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
