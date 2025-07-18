import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Myownnotification extends StatefulWidget {
  const Myownnotification({super.key});

  @override
  State<Myownnotification> createState() => _MyownnotificationState();
}

class _MyownnotificationState extends State<Myownnotification> {

  Future<void> _checkNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    debugger();
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
    return InkWell(
      child: Container(
        child: ElevatedButton(onPressed: _checkNotificationPermission, child: Text("Get Notification")),
      ),
    );
  }
}
