import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

void registerNotification(flutterLocalNotificationsPlugin) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
          defaultPresentBadge: true,
          requestSoundPermission: true,
          requestBadgePermission: true,
          defaultPresentSound: true,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {
            didReceiveLocalNotificationStream.add(
              ReceivedNotification(
                id: id,
                title: title!,
                body: body!,
                payload: payload!,
              ),
            );
          });
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(
        json.decode(message.data['message']), flutterLocalNotificationsPlugin);
  });
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String payload = notificationResponse.payload!;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
  /*await Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  );*/
}

void configLocalNotification(flutterLocalNotificationsPlugin) {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    defaultPresentBadge: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
    defaultPresentSound: true,
  );
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<dynamic> onSelectNotification(payload) async {
  print("hiiiiiiii " + payload);
  List<String> str = payload.replaceAll("{", "").replaceAll("}", "").split(",");
  Map<String, dynamic> result = {};
  var id, subtitle, bigPicture;
  for (int i = 0; i < str.length; i++) {
    List<String> s = str[i].split(":");
    result.putIfAbsent(s[0].trim(), () => s[1].trim());
    if (i == 0) {
      print(s[1].trim());
      subtitle = s[1].trim();
    }
    /*if (subtitle == '"Task Manager"') {
      Get.to(TaskList());
    }*/

    else {
      if (i == 5) {
        // print(s[1].trim());
        bigPicture = s[1].trim();
        bigPicture = bigPicture.replaceAll('"', "");
      }
    }
  }
  /*if (subtitle == '"Task Employee"') {
    Get.to(EmpTaskList());
  }
  if (subtitle == '"Status Employee"') {
    Get.to(StatusHistoryList(type: "Customer"));
  }
  if (subtitle == '"Transfer Employee"') {
    Get.to(TransferList(type: "Customer"));
  }*/
}

void showNotification(message, flutterLocalNotificationsPlugin) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    Platform.isAndroid ? 'com.shreegraphic.shreegraphic' : '',
    'Shree Graphic',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.high,
    visibility: NotificationVisibility.public,
    icon: "@mipmap/ic_launcher",
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
      message['body'].toString(), platformChannelSpecifics,
      payload: json.encode(message));
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<String?> getToken() async {
  return await FirebaseMessaging.instance.getToken();
}
