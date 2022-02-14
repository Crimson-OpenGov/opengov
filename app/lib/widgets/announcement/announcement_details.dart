import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/details/poll_details.dart';
import 'package:opengov_common/models/announcement.dart';
import 'package:opengov_common/models/poll.dart';

class AnnouncementDetails extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementDetails({required this.announcement});

  @override
  _AnnouncementDetailsState createState() => _AnnouncementDetailsState();
}

class _AnnouncementDetailsState extends State<AnnouncementDetails> {
  Poll? _poll;
  var loaded = false;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final response =
        await HttpService.getAnnouncementDetails(widget.announcement);

    if (response != null) {
      setState(() {
        _poll = response.poll;
        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Announcement')),
        body: !loaded
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Text(
                      widget.announcement.title,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.announcement.description,
                      style: const TextStyle(fontSize: 20),
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
