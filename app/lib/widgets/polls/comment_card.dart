import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_common/models/comment.dart';

enum CommentAction { agree, disagree, pass }

extension CommentActionScore on CommentAction {
  static const _scoreMap = {
    CommentAction.agree: 1,
    CommentAction.disagree: -1,
    CommentAction.pass: 0,
  };

  int get score => _scoreMap[this]!;
}

typedef ActionPressed = void Function(CommentAction action, String? reason);

class CommentCard extends StatefulWidget {
  final Comment comment;
  final ActionPressed onActionPressed;

  const CommentCard({required this.comment, required this.onActionPressed});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final _reasonController = TextEditingController();

  void _onHelpPressed() {
    showMessageDialog(
      context,
      title: 'Share a reason',
      body: 'You can optionally include a reason along with your vote. Your '
          'reason will only be visible to Crimson OpenGov admins, who will '
          'share the reasons with Harvard administrators making decisions.\n\n'
          'However, just like your votes and responses, all reasons are '
          'anonymous–no personally identifying info is shared with your '
          'responses.',
    );
  }

  void _onVotePressed(CommentAction action) {
    final reason = _reasonController.text;
    widget.onActionPressed(action, reason.isEmpty ? null : reason);
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.comment.comment),
          const SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              hintText: "Share a reason (anonymous; optional)",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.help),
                onPressed: _onHelpPressed,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _onVotePressed(CommentAction.agree);
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
                  _onVotePressed(CommentAction.disagree);
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
                  _onVotePressed(CommentAction.pass);
                },
                child: const Text('Pass / Unsure'),
              ),
            ],
          ),
        ],
      );

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
