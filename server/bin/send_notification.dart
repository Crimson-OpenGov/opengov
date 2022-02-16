import 'dart:io';

import 'package:opengov_server/util/firebase.dart';

final fcmToken = Platform.environment['FCM_TOKEN'];

Future<void> main() async {
  await Firebase.setup();
  print(await Firebase.sendNotification(
    title: 'Test Notification',
    body: 'This is a test notification from send_notification.dart',
    fcmToken: fcmToken,
    data: {'pollId': 9},
    forceOnDev: true,
  ));
}
