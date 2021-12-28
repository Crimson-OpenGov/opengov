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
  List<Poll>? _polls;

  @override
  void initState() {
    super.initState();
    _fetchPolls();
  }

  Future<void> _fetchPolls() async {
    final response = await HttpService.listPolls();

    if (response != null) {
      setState(() {
        _polls = response.polls;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Polls')),
        body: _polls == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  for (final poll in _polls!)
                    ListTile(
                      leading: const Icon(Icons.poll),
                      title: Text(poll.topic),
                      subtitle: Text('Ends in ${poll.endFormatted}.'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PollDetails(poll: poll)));
                      },
                    ),
                ],
              ),
      );
}
