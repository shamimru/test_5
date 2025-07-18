import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


import 'MyLocalNotification.dart';
import 'ShowPersonData.dart';
import 'main.dart';

class NotificationUtilities {

  var mylocalnotification = Mylocalnotification();
  static Future<void> initialize() async {
    await AwesomeNotifications()
        .initialize("resource://drawable/bell", [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.teal,
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),
        ]);

    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod);
  }

 static Future<void> onActionReceivedMethod(ReceivedAction recivedAction)async {
    final payload= recivedAction.payload ?? {};
    if(payload["navigate"]== "true"){
      MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_)=> Showpersondata()));
    }

  }


  static Future<void> createPlaneNotification() async {
    print("createPlaneNotification");
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 4,
        channelKey: "basic_channel",
        title:
            "${Emojis.money_money_bag + Emojis.emotion_beating_heart} Bye some Food",
        body: "Floral at 123 Main st, has 2 in shamim",
        bigPicture: 'asset://images/food1.jpg',
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'navigate': 'true'},
        chronometer:Duration.zero,
        timeoutAfter: Duration(seconds: 10),
      ),
    );
  }

  static Future<void> createPlaneNotification_2() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
      print("Notification permission not granted.");
      return; // Prevent from crashing
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Plane mode activated',
        body: 'You are now in plane mode',
      ),
    );
  }
}
