import 'dart:async';

import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/login/login_view.dart';
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
  Iterable<Poll>? _activePolls;
  Iterable<Poll>? _inactivePolls;
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
          _activePolls = pollsResponse.polls.where((poll) => poll.isActive);
          _inactivePolls = pollsResponse.polls.where((poll) => !poll.isActive);
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

  Future<void> _createPoll() async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => const CreatePoll(),
    );

    if (saved ?? false) {
      _fetchData();
    }
  }

  Widget _listHeader(String title) => ListTile(
        title: Text(title),
        visualDensity: VisualDensity.compact,
        textColor: Theme.of(context).primaryColor,
        tileColor: Colors.grey.shade300,
      );

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
            if (_me?.isAdmin ?? false)
              IconButton(
                onPressed: _createPoll,
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        body: _activePolls == null || _inactivePolls == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView(
                  children: [
                    if (_activePolls!.isNotEmpty) ...[
                      _listHeader('Active'),
                      for (final poll in _activePolls!) _pollListTile(poll),
                    ],
                    if (_inactivePolls!.isNotEmpty) ...[
                      _listHeader('Inactive'),
                      for (final poll in _inactivePolls!) _pollListTile(poll),
                    ],
                  ],
                ),
              ),
      );
}
