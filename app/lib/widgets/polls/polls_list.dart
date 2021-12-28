import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/poll_details.dart';
import 'package:opengov_common/models/poll.dart';

class PollsList extends StatefulWidget {
  const PollsList();

  @override
  _PollsListState createState() => _PollsListState();
}

class _PollsListState extends State<PollsList> {
  Iterable<Poll>? _activePolls;
  Iterable<Poll>? _inactivePolls;

  @override
  void initState() {
    super.initState();
    _fetchPolls();
  }

  Future<void> _fetchPolls() async {
    final response = await HttpService.listPolls();

    if (response != null) {
      setState(() {
        _activePolls = response.polls.where((poll) => poll.isActive);
        _inactivePolls = response.polls.where((poll) => !poll.isActive);
      });
    }
  }

  Widget _listHeader(String title) => ListTile(
    title: Text(title),
    visualDensity: VisualDensity.compact,
    tileColor: Theme.of(context).primaryColor,
    textColor: Theme.of(context).colorScheme.onPrimary,
  );

  Widget _pollListTile(Poll poll) {
    final isActive = poll.isActive;
    final subtitleLeading = isActive ? 'Ends in' : 'Ended';
    final subtitleTrailing = isActive ? '' : ' ago';

    return ListTile(
        leading: const Icon(Icons.poll),
        title: Text(poll.topic),
        subtitle: Text('$subtitleLeading ${poll.endFormatted}$subtitleTrailing.'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => PollDetails(poll: poll)));
        },
      );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Polls'), elevation: 0,),
        body: _activePolls == null || _inactivePolls == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
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
      );
}
