import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationLocal {
  static Future init() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    FirebaseMessaging.onMessage.listen((event) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: "firebase",
          title: event.notification?.title,
          body: event.notification?.body,
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2,
          channelKey: "firebase",
          title: event.notification?.title,
          body: event.notification?.body,
        ),
      );
    });
  }
}