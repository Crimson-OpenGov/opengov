import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/service/user_service.dart';
import 'package:opengov_app/widgets/announcement/announcement_details.dart';
import 'package:opengov_app/widgets/announcement/edit_announcement.dart';
import 'package:opengov_common/actions/list_announcements.dart';

class AnnouncementsList extends StatefulWidget {
  const AnnouncementsList();

  @override
  _AnnouncementsListState createState() => _AnnouncementsListState();
}

class _AnnouncementsListState extends State<AnnouncementsList> {
  List<ListedAnnouncement>? _announcements;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final announcementsResponse = await HttpService.listAnnouncements();

    if (announcementsResponse != null) {
      setState(() {
        _announcements = announcementsResponse.announcements;
      });
    }
  }

  Future<void> _createAnnouncement() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const EditAnnouncement(),
    );

    if (result != null) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Announcements'),
          elevation: 0,
          actions: [
            if (UserService.user.isAdmin)
              IconButton(
                onPressed: _createAnnouncement,
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
                                  announcementId: announcement.id),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
      );
}
