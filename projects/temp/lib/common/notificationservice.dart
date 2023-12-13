import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {
  AudioPlayer player = AudioPlayer();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (payload) {
      LocalNotificationService().player.setReleaseMode(ReleaseMode.stop);
    }, onDidReceiveNotificationResponse: (payload) {
      LocalNotificationService().player.setReleaseMode(ReleaseMode.stop);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      LocalNotificationService().player.setReleaseMode(ReleaseMode.stop);
      if (message.data['type'] != null) {
        if (message.data['type'] == 'parking') {
          ByteData bytes = await rootBundle
              .load('assets/audios/siren.mp3'); //load sound from assets
          Uint8List soundbytes = bytes.buffer
              .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
          await LocalNotificationService().player.play(BytesSource(soundbytes));
          await LocalNotificationService()
              .player
              .setReleaseMode(ReleaseMode.loop);
        } else if (message.data['type'] == 'navigation') {
          Get.to(homepage());
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      LocalNotificationService().player.setReleaseMode(ReleaseMode.stop);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (message.data['type'] != null) {
        if (message.data['type'] == 'parking') {
          ByteData bytes = await rootBundle
              .load('assets/audios/siren.mp3'); //load sound from assets
          Uint8List soundbytes = bytes.buffer
              .asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

          await LocalNotificationService().player.play(BytesSource(soundbytes));
          await LocalNotificationService()
              .player
              .setReleaseMode(ReleaseMode.loop);
        } else if (message.data['type'] == 'navigation') {
          Get.to(homepage());
        }
      }

      showNotification(message);
    });
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static notifcationPermitions() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<String> notifytoken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    final token = await firebaseMessaging.getToken();
    print("Token Value $token");
    return token.toString();
  }
}

void showNotification(RemoteMessage message) {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'channel_id', 'some_title',
      importance: Importance.high);

  AndroidNotificationDetails details = AndroidNotificationDetails(
      channel.id, channel.name,
      icon: 'launch_background');

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  int id = message.hashCode;
  String title = "some message title";
  String body = message.data["message"];

  plugin.show(id, title, body, NotificationDetails(android: details));
}

Future<void> backgroundHandler(RemoteMessage message) async {
  LocalNotificationService().player.setReleaseMode(ReleaseMode.stop);
  if (message.data['type'] != null) {
    if (message.data['type'] == 'parking') {
      ByteData bytes = await rootBundle
          .load('assets/audios/siren.mp3'); //load sound from assets
      Uint8List soundbytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      await LocalNotificationService().player.play(BytesSource(soundbytes));
      await LocalNotificationService().player.setReleaseMode(ReleaseMode.loop);
    } else if (message.data['type'] == 'navigation') {
      Get.to(homepage());
    }
  }
  print(message.data.toString());
  print(message.notification!.title);
}
