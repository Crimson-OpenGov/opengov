import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/common.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_common/models/reply.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_app/widgets/polls/details/add_reply.dart';
import 'package:opengov_app/widgets/polls/details/reply_list.dart';

class ReplyListView extends StatefulWidget {
  final int commentId;
  const ReplyListView({required this.commentId});

  @override
  State<StatefulWidget> createState() => _ReplyListViewState();
}

class _ReplyListViewState extends State<ReplyListView> {
  Comment? _comment;
  List<Reply>? _replies;

  @override
  void initState() {
    super.initState();
    _fetchReplies();
  }

  Future<void> _fetchReplies() async {
    final response = await HttpService.getCommentReplies(widget.commentId);

    if (response != null) {
      setState(() {
        _comment = response.comment;
        _replies = response.replies;
      });
    }
  }

  Future<void> _updateReply(int i) async {
    final response = await HttpService.getReplyDetails(_replies![i]);

    if (response != null) {
      setState(() {
        _replies![i] = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Replies to Comment')),
    body: _comment == null || _replies == null
    ? const Center(child: CircularProgressIndicator())
    : Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: [
          Text(
            _comment!.comment,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _comment!.timestamp.toString(),
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 16),
          AddReply(comment: _comment!),
          const SizedBox(height: 16),
          ReplyList(
            replies: _replies!,
            onActionPressed: _updateReply
          ),
        ],
      ),
    ),
  );
}
