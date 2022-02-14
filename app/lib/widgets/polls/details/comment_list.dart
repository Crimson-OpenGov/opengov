import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/polls/details/comment_card.dart';
import 'package:opengov_common/models/comment.dart';

class CommentList extends StatefulWidget {
  final List<CommentBase> comments;
  final void Function(int i) onActionPressed;

  const CommentList({required this.comments, required this.onActionPressed});

  @override
  State<StatefulWidget> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.comments.isEmpty
      ? const Text('No more comments.')
      : Column(
          children: [
            for (var i = 0; i < widget.comments.length; i++)
              Padding(
                padding: i < widget.comments.length - 1
                    ? const EdgeInsets.only(bottom: 8)
                    : EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: CommentCard(
                    comment: widget.comments[i],
                    onActionPressed: () {
                      widget.onActionPressed(i);
                    },
                  ),
                ),
              ),
          ],
        );
}
