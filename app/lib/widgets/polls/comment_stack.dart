import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/comment_card.dart';
import 'package:opengov_common/actions/vote.dart';
import 'package:opengov_common/models/comment.dart';

class CommentStack extends StatefulWidget {
  final List<Comment> comments;

  const CommentStack({required this.comments});

  @override
  State<StatefulWidget> createState() => _CommentStackState();
}

class _CommentStackState extends State<CommentStack> {
  var _index = 0;

  Comment get _comment => widget.comments[_index];

  Future<void> _onActionPressed(CommentAction action, String? reason) async {
    final response = await HttpService.vote(VoteRequest(
        commentId: _comment.id, score: action.score, reason: reason));

    if (response?.success ?? false) {
      setState(() {
        _index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _index >= widget.comments.length
              ? const Text('No more comments.')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CommentCard(
                      comment: _comment,
                      onActionPressed: _onActionPressed,
                    ),
                    Text('Comment ${_index + 1}/${widget.comments.length}'),
                  ],
                ),
        ),
      );
}
