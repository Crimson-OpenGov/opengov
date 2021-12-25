import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/polls/add_comment.dart';
import 'package:opengov_app/widgets/polls/comment_stack.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/actions/poll_details.dart';
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
    final response = PollDetailsResponse(comments: [
      const Comment(
        id: 0,
        pollId: 0,
        userId: 0,
        comment:
            "I don't mind losing shopping week entirely. Other colleges don't "
            "have it, and we should just register for courses based on Q "
            "guides",
      ),
      const Comment(
        id: 1,
        pollId: 0,
        userId: 1,
        comment:
            'We should fight tooth and nail to keep shopping week exactly how '
            'it is',
      ),
      const Comment(
        id: 2,
        pollId: 0,
        userId: 2,
        comment: 'I liked what they did this year. As long as I can see the '
            'professor give a sample lecture, even via zoom, I am satisfied.',
      ),
    ]);

    setState(() {
      _comments = response.comments;
    });
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
                    Text(
                      widget.poll.description,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    CommentStack(comments: _comments!),
                    const SizedBox(height: 16),
                    const AddComment(),
                  ],
                ),
              ),
      );
}
