import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/announcement/announcement_details.dart';
import 'package:opengov_app/widgets/polls/details/poll_details.dart';

class NotificationService {
  static Future<void> setup(BuildContext context) async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, context);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message, context);
    });
  }

  static void _handleMessage(RemoteMessage message, BuildContext context) {
    if (message.data.containsKey('pollId')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                PollDetails(parentId: int.parse(message.data['pollId']), isReply: false)),
      );
    } else if (message.data.containsKey('announcementId')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AnnouncementDetails(
                announcementId: int.parse(message.data['announcementId']))),
      );
    }
  }
}
