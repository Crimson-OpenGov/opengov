import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/base/list_header.dart';
import 'package:opengov_app/widgets/polls/neapolitan.dart';
import 'package:opengov_common/actions/update_comment.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';

class PollAdmin extends StatefulWidget {
  final Poll poll;

  const PollAdmin({required this.poll});

  @override
  _PollAdminState createState() => _PollAdminState();
}

class _PollAdminState extends State<PollAdmin> {
  Iterable<Comment>? _moderationQueue;
  Iterable<Comment>? _approvedComments;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final response = await HttpService.getReport(widget.poll);

    if (response != null) {
      setState(() {
        _moderationQueue =
            response.comments.where((comment) => !comment.isApproved);
        _approvedComments =
            response.comments.where((comment) => comment.isApproved);
      });
    }
  }

  Future<void> _updateComment(
      Comment comment, UpdateCommentAction action) async {
    final response = await HttpService.updateComment(
        UpdateCommentRequest(commentId: comment.id, action: action));

    if (response?.success ?? false) {
      await _fetchComments();
    }
  }

  Widget _commentListTile(Comment comment) => Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(comment.comment)),
            const SizedBox(width: 16),
            Neapolitan(
              pieces: [
                comment.stats!.agreeCount,
                comment.stats!.passCount,
                comment.stats!.disagreeCount,
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
                _updateComment(comment, UpdateCommentAction.delete);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              tooltip: 'Delete comment',
            ),
            if (!comment.isApproved)
              IconButton(
                onPressed: () {
                  _updateComment(comment, UpdateCommentAction.approve);
                },
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                tooltip: 'Approve comment',
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Poll Admin')),
        body: _moderationQueue == null || _approvedComments == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.poll.topic,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (widget.poll.description != null) ...[
                          Text(
                            widget.poll.description!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                  if (_moderationQueue!.isNotEmpty) ...[
                    const ListHeader('Moderation Queue'),
                    for (final comment in _moderationQueue!)
                      _commentListTile(comment),
                  ],
                  if (_approvedComments!.isNotEmpty) ...[
                    const ListHeader('Approved Comments'),
                    for (final comment in _approvedComments!)
                      _commentListTile(comment),
                  ],
                ],
              ),
      );
}
