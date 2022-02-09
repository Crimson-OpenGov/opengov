import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/announcement/announcement_details.dart';
import 'package:opengov_common/actions/list_announcements.dart';
import 'package:opengov_common/models/user.dart';

class AnnouncementsList extends StatefulWidget {
  const AnnouncementsList();

  @override
  _AnnouncementsListState createState() => _AnnouncementsListState();
}

class _AnnouncementsListState extends State<AnnouncementsList> {
  List<ListedAnnouncement>? _announcements;
  User? _me;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final responses = await Future.wait(
        [HttpService.getMe(), HttpService.listAnnouncements()]);

    if (responses.every((response) => response != null)) {
      final meResponse = responses[0] as User;
      final announcementsResponse = responses[1] as ListAnnouncementsResponse;

      setState(() {
        _me = meResponse;
        _announcements = announcementsResponse.announcements;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Announcements'),
          elevation: 0,
          actions: [
            if (_me?.isAdmin ?? false)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: _announcements == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView(
                  children: [
                    for (final announcement in _announcements!)
                      ListTile(
                        isThreeLine: true,
                        leading: Text(
                          announcement.emoji ?? 'X',
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(announcement.title),
                        subtitle: Text(
                          announcement.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing:
                            Text('${announcement.postedTimeFormatted} ago'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AnnouncementDetails(
                                  announcement: announcement),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
      );
}
