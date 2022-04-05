import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/base/dialogs.dart';
import 'package:opengov_app/widgets/base/linked_text.dart';
import 'package:opengov_app/widgets/base/list_header.dart';
import 'package:opengov_app/widgets/polls/edit_poll.dart';
import 'package:opengov_app/widgets/polls/neapolitan.dart';
import 'package:opengov_common/actions/delete_poll.dart';
import 'package:opengov_common/actions/update_comment.dart';
import 'package:opengov_common/actions/update_reply.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/reply.dart';

class CommentAdmin extends StatefulWidget {
  final Comment comment;

  const CommentAdmin({required this.comment});

  @override
  _CommentAdminState createState() => _CommentAdminState();
}

class _CommentAdminState extends State<CommentAdmin> {
  late Comment _comment;
  Iterable<Reply>? _moderationQueue;
  Iterable<Reply>? _approvedReplies;

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
    _fetchReplies();
  }

  @override
  void didUpdateWidget(covariant CommentAdmin oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.comment != oldWidget.comment) {
      _comment = widget.comment;
      _fetchReplies();
    }
  }

  Future<void> _fetchReplies() async {
    final response = await HttpService.getReplyReport(_comment);

    if (response != null) {
      setState(() {
        _moderationQueue =
            response.replies.where((reply) => !reply.isApproved);
        _approvedReplies =
            response.replies.where((reply) => reply.isApproved);
      });
    }
  }

  Future<void> _updateReply(Reply reply, UpdateReplyAction action) async { 
    final response = await HttpService.updateReply(
        UpdateReplyRequest(replyId: reply.id, action: action));

    if (response?.success ?? false) {
      await _fetchReplies();
    }
  }

  /*Future<void> _deleteComment() async {
    final shouldDelete = await showConfirmationDialog(context,
        body: 'Are you sure you want to delete this comment?');

    if (shouldDelete) {
      final response =
          await HttpService.deleteComment(DeleteCommentRequest(commentId: _comment.id));

      if (response?.success ?? false) {
        Navigator.pop(context);
      }
    }
  }*/

  /*Future<void> _editComment() async {
    final comment = await showDialog<Comment?>(
      context: context,
      builder: (_) => EditComment(comment: _comment), //need this
    );

    if (comment != null) {
      setState(() {
        _comment = comment;
      });
    }
  }*/

  Widget _replyListTile(Reply reply) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: LinkedText(reply.reply)),
            const SizedBox(width: 16),
            Neapolitan(
              pieces: [
                reply.stats!.agreeCount,
                reply.stats!.passCount,
                reply.stats!.disagreeCount,
              ],
              colors: const [
                Colors.green,
                Colors.white,
                Colors.red,
              ],
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                _updateReply(reply, UpdateReplyAction.delete);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              tooltip: 'Delete reply',
            ),
            if (!reply.isApproved)
              IconButton(
                onPressed: () {
                  _updateReply(reply, UpdateReplyAction.approve);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                tooltip: 'Approve reply',
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Reply Admin'),
          /*actions: [
            IconButton(
              onPressed: _deleteComment,
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: _editComment,
              icon: const Icon(Icons.edit),
            ),
          ],*/
        ),
        body: _moderationQueue == null || _approvedReplies == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comment '+_comment.id.toString(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinkedText(
                          _comment.comment,
                          fontSize: 18,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (_moderationQueue!.isNotEmpty) ...[
                    const ListHeader('Moderation Queue'),
                    for (final reply in _moderationQueue!)
                      _replyListTile(reply),
                  ],
                  if (_approvedReplies!.isNotEmpty) ...[
                    const ListHeader('Approved Replies'),
                    for (final reply in _approvedReplies!)
                      _replyListTile(reply),
                  ],
                ],
              ),
      );
}
