import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/base/list_header.dart';
import 'package:opengov_app/widgets/login/login_view.dart';
import 'package:opengov_app/widgets/polls/about_page.dart';
import 'package:opengov_app/widgets/polls/create_poll.dart';
import 'package:opengov_app/widgets/polls/poll_admin.dart';
import 'package:opengov_app/widgets/polls/poll_details.dart';
import 'package:opengov_app/widgets/polls/poll_report.dart';
import 'package:opengov_common/actions/list_polls.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PollsList extends StatefulWidget {
  const PollsList();

  @override
  _PollsListState createState() => _PollsListState();
}

class _PollsListState extends State<PollsList> {
  Iterable<Poll>? _timelyPolls;
  Iterable<Poll>? _permanentPolls;
  Iterable<Poll>? _finishedPolls;
  User? _me;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final responses =
          await Future.wait([HttpService.getMe(), HttpService.listPolls()]);

      if (responses.every((response) => response != null)) {
        final meResponse = responses[0] as User;
        final pollsResponse = responses[1] as ListPollsResponse;

        setState(() {
          _me = meResponse;
          _timelyPolls = pollsResponse.polls
              .where((poll) => poll.isActive && !poll.isPermanent);
          _permanentPolls = pollsResponse.polls
              .where((poll) => poll.isActive && poll.isPermanent);
          _finishedPolls = pollsResponse.polls.where((poll) => !poll.isActive);
        });
      }
    } on AuthenticationException {
      (await SharedPreferences.getInstance()).clear();

      unawaited(Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (_) => false,
      ));

      showMessageDialog(context,
          body: 'Your session has expired. Please log in again.');
    }
  }

  void _openAbout() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const AboutPage()));
  }

  Future<void> _createPoll() async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => const CreatePoll(),
    );

    if (saved ?? false) {
      _fetchData();
    }
  }

  Widget _pollListTile(Poll poll) {
    final isActive = poll.isActive;
    final subtitleLeading = isActive ? 'Ends in' : 'Ended';
    final subtitleTrailing = isActive ? '' : ' ago';
    final isAdmin = _me!.isAdmin;

    return ListTile(
      leading: const Icon(Icons.poll),
      title: Text(poll.topic),
      subtitle: Text('$subtitleLeading ${poll.endFormatted}$subtitleTrailing.'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => poll.isActive
                ? isAdmin
                    ? PollAdmin(poll: poll)
                    : PollDetails(poll: poll)
                : PollReport(poll: poll),
          ),
        );
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
            if (_me?.isAdmin ?? false)
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
