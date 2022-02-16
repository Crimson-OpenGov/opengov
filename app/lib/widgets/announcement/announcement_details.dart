import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/details/poll_details.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/poll.dart';

class AnnouncementDetails extends StatefulWidget {
  final int announcementId;

  const AnnouncementDetails({required this.announcementId});

  @override
  _AnnouncementDetailsState createState() => _AnnouncementDetailsState();
}

class _AnnouncementDetailsState extends State<AnnouncementDetails> {
  Announcement? _announcement;
  Poll? _poll;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final response =
        await HttpService.getAnnouncementDetails(widget.announcementId);

    if (response != null) {
      setState(() {
        _announcement = response.announcement;
        _poll = response.poll;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Announcement')),
        body: _announcement == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Text(
                      _announcement!.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _announcement!.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                    if (_poll != null) ...[
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Text(
                          _poll!.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(_poll!.topic),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PollDetails(pollId: _poll!.id)),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
      );
}
