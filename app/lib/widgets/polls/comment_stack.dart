import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/polls/comment_card.dart';
import 'package:opengov_common/models/comment.dart';

class CommentStack extends StatefulWidget {
  final List<Comment> comments;

  const CommentStack({required this.comments});

  @override
  State<StatefulWidget> createState() => _CommentStackState();
}

class _CommentStackState extends State<CommentStack> {
  var index = 0;

  void _onActionPressed(CommentAction action) {
    setState(() {
      index++;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: index >= widget.comments.length
              ? const Text('No more comments.')
              : CommentCard(
                  comment: widget.comments[index],
                  onActionPressed: _onActionPressed,
                ),
        ),
      );
}
