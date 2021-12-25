import 'package:flutter/material.dart';
import 'package:opengov_common/models/comment.dart';

enum CommentAction { agree, disagree, pass }

typedef ActionPressed = void Function(CommentAction action);

class CommentCard extends StatelessWidget {
  final Comment comment;
  final ActionPressed onActionPressed;

  const CommentCard({required this.comment, required this.onActionPressed});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.comment),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  onActionPressed(CommentAction.agree);
                },
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Agree'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  onActionPressed(CommentAction.disagree);
                },
                child: Row(
                  children: const [
                    Icon(Icons.block, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Disagree'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  onActionPressed(CommentAction.pass);
                },
                child: const Text('Pass / Unsure'),
              ),
            ],
          ),
        ],
      );
}
