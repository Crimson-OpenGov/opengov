import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/details/add_comment.dart';
import 'package:opengov_app/widgets/polls/details/comment_list.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';

class PollDetails extends StatefulWidget {
  final int pollId;

  const PollDetails({required this.pollId});

  @override
  _PollDetailsState createState() => _PollDetailsState();
}

class _PollDetailsState extends State<PollDetails> {
  Poll? _poll;
  List<Comment>? _comments;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final response = await HttpService.getPollDetails(widget.pollId);

    if (response != null) {
      setState(() {
        _poll = response.poll;
        _comments = response.comments;
      });
    }
  }

  Future<void> _updateComment(int i) async {
    final response = await HttpService.getCommentDetails(_comments![i]);

    if (response != null) {
      setState(() {
        _comments![i] = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Poll')),
        body: _poll == null || _comments == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Text(
                      _poll!.topic,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_poll!.description != null) ...[
                      Text(
                        _poll!.description!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                    ],
                    AddComment(poll: _poll!),
                    const SizedBox(height: 16),
                    CommentList(
                      comments: _comments!,
                      onActionPressed: _updateComment,
                    ),
                  ],
                ),
              ),
      );
}
