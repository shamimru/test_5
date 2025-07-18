import 'dart:developer';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_camera_android/flutter_hidden_camera_android.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parental_gates/parental_gates.dart';

import 'MyOwnNotification.dart';
import 'NotificationUtilities.dart';

class Mylocalnotification extends StatefulWidget {
  const Mylocalnotification({super.key});

  @override
  State<Mylocalnotification> createState() => _MylocalnotificationState();
}

class _MylocalnotificationState extends State<Mylocalnotification> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  var check;

  @override
  void initState() {
    super.initState();
    check = isNotificationAllowed();
  }

  // to check access permission
  Future<bool> isNotificationAllowed() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  Future<void> _checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Allow Notification"),
            content: const Text(
              "Our app would like to send you notifications.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Don't Allow"),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Get.back());
                },
                child: const Text("Allow"),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (await isNotificationAllowed() != true) {
                  print("inside method ${isNotificationAllowed() != true}");
                  NotificationUtilities.createPlaneNotification_2();
                }
                NotificationUtilities.createPlaneNotification();
              },
              child: Text("show Notification"),
            ),

            ElevatedButton(
              onPressed: () {
                Get.toNamed("/getContacts");
              },
              child: Text("Get Contact List"),
            ),

            ElevatedButton(
              onPressed: () async {
                // final ImagePicker _picker = ImagePicker();
                // XFile? _imageFile;
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );

                setState(() {
                  _imageFile = image;
                });
                if (image != null) {
                  try {
                    await Gal.putImage(image.path);
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                }
              },
              child: Text("Take a picture"),
            ),
            SizedBox(height: 50),
            SingleChildScrollView(
              child: Center(
                child: _imageFile != null?
                Container(child: Image.file(File(_imageFile!.path),fit: BoxFit.fill,)):
                CircularProgressIndicator(),
              ),
            ),

            ElevatedButton(
                onPressed: () {
                  Permission.getPermission(
                    context: context,
                    onSuccess: () {
                      print("True");
                    },
                    onFail: () {
                      print("false");
                    },
                  );
                },
                child: Text("validate")
            ),

          ],
        ),
      ),
    );
  }
}
