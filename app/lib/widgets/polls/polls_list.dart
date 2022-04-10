import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/service/user_service.dart';
import 'package:opengov_app/widgets/base/list_header.dart';
import 'package:opengov_app/widgets/polls/about_page.dart';
import 'package:opengov_app/widgets/polls/edit_poll.dart';
import 'package:opengov_app/widgets/polls/details/poll_details.dart';
import 'package:opengov_app/widgets/polls/poll_admin.dart';
import 'package:opengov_app/widgets/polls/poll_report.dart';
import 'package:opengov_common/models/poll.dart';

class PollsList extends StatefulWidget {
  const PollsList();

  @override
  _PollsListState createState() => _PollsListState();
}

class _PollsListState extends State<PollsList> {
  Iterable<Poll>? _timelyPolls;
  Iterable<Poll>? _permanentPolls;
  Iterable<Poll>? _finishedPolls;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final pollsResponse = await HttpService.listPolls();

    if (kDebugMode) {
      await UserService.getUser(context);
    }

    if (pollsResponse != null) {
      setState(() {
        _timelyPolls = pollsResponse.polls
            .where((poll) => poll.isActive && !poll.isPermanent);
        _permanentPolls = pollsResponse.polls
            .where((poll) => poll.isActive && poll.isPermanent);
        _finishedPolls = pollsResponse.polls.where((poll) => !poll.isActive);
      });
    }
  }

  void _openAbout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AboutPage()));
  }

  Future<void> _createPoll() async {
    final poll = await showDialog<Poll?>(
      context: context,
      builder: (_) => const EditPoll(),
    );

    if (poll != null) {
      _fetchData();
    }
  }

  Widget _pollListTile(Poll poll) {
    final isActive = poll.isActive;
    final subtitleLeading = isActive ? 'Ends in' : 'Ended';
    final subtitleTrailing = isActive ? '' : ' ago';
    final isAdmin = UserService.user.isAdmin;

    return ListTile(
      leading: Text(
        poll.emoji,
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(poll.topic),
      subtitle: Text('$subtitleLeading ${poll.endFormatted}$subtitleTrailing.'),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => poll.isActive
                ? isAdmin 
                ? PollAdmin(poll: poll, comment: null, isReply: false)
                    : PollDetails(parentId: poll.id, isReply: false)
                : PollReport(poll: poll),
          ),
        );

        if (isAdmin) {
          _fetchData();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Polls'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _openAbout,
              icon: const Icon(Icons.info),
            ),
            if (UserService.user.isAdmin)
              IconButton(
                onPressed: _createPoll,
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: _timelyPolls == null ||
                _permanentPolls == null ||
                _finishedPolls == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView(
                  children: [
                    if (_timelyPolls!.isNotEmpty) ...[
                      const ListHeader('Timely'),
                      for (final poll in _timelyPolls!) _pollListTile(poll),
                    ],
                    if (_permanentPolls!.isNotEmpty) ...[
                      const ListHeader('Permanent'),
                      for (final poll in _permanentPolls!) _pollListTile(poll),
                    ],
                    if (_finishedPolls!.isNotEmpty) ...[
                      const ListHeader('Finished'),
                      for (final poll in _finishedPolls!) _pollListTile(poll),
                    ],
                  ],
                ),
              ),
      );
}
