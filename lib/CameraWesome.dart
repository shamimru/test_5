import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraAwesome extends StatefulWidget {
  const CameraAwesome({super.key});

  @override
  State<CameraAwesome> createState() => _CameraAwesomeState();
}

class _CameraAwesomeState extends State<CameraAwesome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Awesome"),
      ),
      backgroundColor: Colors.green,
      body: CameraAwesomeBuilder.awesome(
        onMediaCaptureEvent: (event) {
          switch ((event.status, event.isPicture, event.isVideo)) {
            case (MediaCaptureStatus.capturing, true, false):
              debugPrint("capturing picture");
              break;
            case (MediaCaptureStatus.success, true, false):
              event.captureRequest.when(
                single: (single) {
                  debugPrint("picture saved: ${single.file?.path}");
                },
              );
              break;
            case (MediaCaptureStatus.capturing, false, true):
              debugPrint("capturing video");
              break;
            case (MediaCaptureStatus.success, false, true):
              event.captureRequest.when(
                single: (single) {
                  debugPrint("video saved: ${single.file?.path}");
                },
              );
              break;
            default:
              debugPrint("Unknown event: $event");
          }
        },
        saveConfig: SaveConfig.photoAndVideo(
          initialCaptureMode: CaptureMode.photo,
          photoPathBuilder: (sensors) async {
            final Directory extDir = await getTemporaryDirectory();
            final testDir = await Directory(
              "${extDir.path}/camerawesome",
            ).create(recursive: true);

            if (sensors.length == 1) {
              final String filePath = "${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
              return SingleCaptureRequest(filePath, sensors.first);
            } else {
              // Handle multiple sensors case
              final String filePath = "${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
              return SingleCaptureRequest(filePath, sensors.first);
            }
          },
          videoPathBuilder: (sensors) async {
            final Directory extDir = await getTemporaryDirectory();
            final testDir = await Directory(
              "${extDir.path}/camerawesome",
            ).create(recursive: true);

            if (sensors.length == 1) {
              final String filePath = "${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
              return SingleCaptureRequest(filePath, sensors.first);
            } else {
              // Handle multiple sensors case
              final String filePath = "${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
              return SingleCaptureRequest(filePath, sensors.first);
            }
          },
        ),
        previewPadding: EdgeInsets.all(5),
        previewAlignment: Alignment.center,
      ),
    );
  }
}

