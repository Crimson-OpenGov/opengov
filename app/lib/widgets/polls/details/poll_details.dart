import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/details/add_comment.dart';
import 'package:opengov_app/widgets/polls/details/comment_list.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';

class PollDetails extends StatefulWidget {
  final Poll poll;

  const PollDetails({required this.poll});

  @override
  _PollDetailsState createState() => _PollDetailsState();
}

class _PollDetailsState extends State<PollDetails> {
  List<Comment>? _comments;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final response = await HttpService.getPollDetails(widget.poll);

    if (response != null) {
      setState(() {
        _comments = response.comments;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Poll')),
        body: _comments == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Text(
                      widget.poll.topic,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.poll.description != null) ...[
                      Text(
                        widget.poll.description!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                    ],
                    AddComment(poll: widget.poll),
                    const SizedBox(height: 16),
                    CommentList(
                      comments: _comments!,
                      onActionPressed: _fetchComments,
                    ),
                  ],
                ),
              ),
      );
}
