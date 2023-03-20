import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static Future<void> receiveForegroundNotification(RemoteMessage message) async {
    log("FCM message notification ${message.data}");

    /*  LocalNotification.showBigTextNotification(
        title: message.notification!.title ?? "",
        body: message.notification!.body ?? "",
        fln: flutterLocalNotificationsPlugin!); */
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("FCM message ${message.data}");
    /*   LocalNotification.showBigTextNotification(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
        fln: flutterLocalNotificationsPlugin!); */
  }
}

class LocalNotification {
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification({var id = 0, required String title, required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(presentSound: true, presentAlert: true, interruptionLevel: InterruptionLevel.active);

    var not = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosDetails);
    await fln.show(0, title, body, not);
  }
}
