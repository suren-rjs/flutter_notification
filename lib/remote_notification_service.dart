import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_c/notification_service.dart';

class RemoteNotificationService {
  RemoteNotificationService() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    initNotificationSettings(messaging);
  }

  Future<void> initNotificationSettings(FirebaseMessaging messaging) async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint(
        '----------------------------------------------------------------------------');
    debugPrint(fcmToken);
    debugPrint(
        '----------------------------------------------------------------------------');
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Message data: ${message.data}');
      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification?.title}');
        debugPrint(
            'Message also contained a notification: ${message.notification?.body}');
      }
      notificationService.showForegroundNotifications(
        message.notification?.title,
        message.notification?.body,
      );
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Handling a background message ${message.messageId}');
  }
}
