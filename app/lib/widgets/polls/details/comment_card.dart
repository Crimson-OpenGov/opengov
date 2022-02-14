import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/neapolitan.dart';
import 'package:opengov_common/actions/feed.dart';
import 'package:opengov_common/actions/vote.dart';
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

class CommentCard extends StatefulWidget {
  final CommentBase comment;
  final VoidCallback onActionPressed;

  const CommentCard({required this.comment, required this.onActionPressed});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  static const _showReason = false;

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

  Future<void> _onVotePressed(CommentAction action) async {
    final reason = _reasonController.text;
    final response = await HttpService.vote(VoteRequest(
        commentId: widget.comment.id, score: action.score, reason: reason));

    if (response?.success ?? false) {
      widget.onActionPressed();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.comment is FeedComment) ...[
            ListTile(
              leading: Text(
                (widget.comment as FeedComment).pollEmoji,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text((widget.comment as FeedComment).pollTopic),
            ),
            const Divider(),
          ],
          Text(
            widget.comment.comment,
            style: const TextStyle(fontSize: 16),
          ),
          if (_showReason) ...[
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
          ],
          const SizedBox(height: 8),
          widget.comment.stats == null
              ? SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        onPressed: () {
                          _onVotePressed(CommentAction.agree);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle_outline,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Agree',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        onPressed: () {
                          _onVotePressed(CommentAction.disagree);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.block, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Disagree',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        onPressed: () {
                          _onVotePressed(CommentAction.pass);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.redo, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Unsure/Neutral',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Neapolitan(
                    pieces: [
                      widget.comment.stats!.agreeCount,
                      widget.comment.stats!.passCount,
                      widget.comment.stats!.disagreeCount
                    ],
                    colors: const [Colors.green, Colors.white, Colors.red],
                  ),
                ),
        ],
      );

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
