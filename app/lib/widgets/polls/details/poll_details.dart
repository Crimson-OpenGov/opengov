import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/base/linked_text.dart';
import 'package:opengov_app/widgets/polls/details/add_comment.dart';
import 'package:opengov_app/widgets/polls/details/comment_list.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/poll.dart';

class PollDetails extends StatefulWidget {
  final int parentId; //parent is a poll if not reply, and comment otherwise
  final isReply;
  const PollDetails({required this.parentId, required this.isReply});
  
  @override
  _PollDetailsState createState() => _PollDetailsState();
}

class _PollDetailsState extends State<PollDetails> {
  Map<String,dynamic>? _parentText;
  List<Comment>? _comments;
  
  @override
  void initState() {  
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final response;
    if (!widget.isReply) {
      response = await HttpService.getPollDetails(widget.parentId);
    } else {
      response = await HttpService.getCommentReplies(widget.parentId);
    }
    
    if (response != null) {
      setState(() {
          _parentText = response.parent.details;
          _comments = response.messages;
      });
    }
  }

  Future<void> _updateComment(int i) async {
    final response = await HttpService.getCommentDetails(_comments![i]);

    if (response != null) {
      setState(() {
          _comments![i] = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Poll Details')),
    body: _parentText == null || _comments == null
    ? const Center(child: CircularProgressIndicator())
    : Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: [
          Text(
            _parentText!['topic'],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (_parentText!['description'] != null) ...[
            LinkedText(
              _parentText!['description']!,
              fontSize: 18,
            ),
            const SizedBox(height: 16),
          ],
          AddComment(pollId: _parentText!['pollId'], parentId: _parentText!['commentId']),
          const SizedBox(height: 16),
          CommentList(
            comments: _comments!,
            onActionPressed: _updateComment,
            isReply: widget.isReply,
          ),
        ],
      ),
    ),
  );
}
