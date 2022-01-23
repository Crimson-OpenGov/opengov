import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/polls/details/comment_card.dart';
import 'package:opengov_common/models/comment.dart';

class CommentList extends StatefulWidget {
  final List<Comment> comments;

  const CommentList({required this.comments});

  @override
  State<StatefulWidget> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  late List<Comment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
  }

  @override
  void didUpdateWidget(covariant CommentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _comments = widget.comments;
  }

  void _onActionPressed(int i) {
    setState(() {
      _comments.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) => _comments.isEmpty
      ? const Text('No more comments.')
      : Column(
          children: [
            for (var i = 0; i < _comments.length; i++)
              Padding(
                  padding: i < _comments.length - 1
                    ? const EdgeInsets.only(bottom: 8)
                    : EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: CommentCard(
                    comment: _comments[i],
                    onActionPressed: () {
                      _onActionPressed(i);
                    },
                  ),
                ),
              ),
          ],
        );
}
