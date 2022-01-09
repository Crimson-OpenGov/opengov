import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
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
  List<Comment>? _comments;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final response = await HttpService.getPollDetailsAdmin(widget.poll);

    if (response != null) {
      setState(() {
        _comments = response.comments;
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Poll Admin')),
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
                    if (widget.poll.description != null) ...[
                      Text(
                        widget.poll.description!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                    ],
                    for (final comment in _comments!)
                      ListTile(
                        title: Text(comment.comment),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _updateComment(
                                    comment, UpdateCommentAction.delete);
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
                                  _updateComment(
                                      comment, UpdateCommentAction.approve);
                                },
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                tooltip: 'Approve comment',
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      );
}
