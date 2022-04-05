import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/base/linked_text.dart';
import 'package:opengov_app/widgets/polls/details/poll_details.dart';
import 'package:opengov_app/widgets/polls/neapolitan.dart';
import 'package:opengov_common/actions/feed.dart';
import 'package:opengov_common/actions/vote.dart';
import 'package:opengov_common/models/comment.dart';
import 'package:opengov_common/models/reply.dart';
import 'package:opengov_app/widgets/polls/reply_details.dart';
import 'package:opengov_common/actions/vote_reply.dart';

enum ReplyAction { agree, disagree, pass }

extension ReplyActionScore on ReplyAction {
  static const _scoreMap = {
    ReplyAction.agree: 1,
    ReplyAction.disagree: -1,
    ReplyAction.pass: 0,
  };

  int get score => _scoreMap[this]!;
}

class ReplyCard extends StatefulWidget {
  final ReplyBase reply;
  final VoidCallback onActionPressed;

  const ReplyCard({required this.reply, required this.onActionPressed});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
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

  Future<void> _onVotePressed(ReplyAction action) async {
    final reason = _reasonController.text;
    final response = await HttpService.voteReply(VoteReplyRequest(
        replyId: widget.reply.id, score: action.score, reason: reason));

    if (response?.success ?? false) {
      widget.onActionPressed();
    }
  }

  /*
  Future<void> _onReplyPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReplyListView(commentId:widget.reply.comment_id)));

    //final response = await HttpService.vote(VoteRequest(
    //    commentId: widget.comment.id, score: action.score, reason: reason));
    // ReplyListView(widget.comment.id);

    showMessageDialog(
      context,
      title: 'Share a reason',
      body: widget.comment.id.toString(),
    );
    
  }*/
      

  
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /* if (widget.reply is FeedReply) ...[
        ListTile(
          leading: Text(
            (widget.reply as FeedReply).pollEmoji,
            style: const TextStyle(fontSize: 24),
          ),
          title: Text((widget.reply as FeedReply).pollTopic),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PollDetails(
                  pollId: (widget.reply as FeedReply).pollId)),
            );
          },
        ),
        const Divider(),
      ], */
      LinkedText(
        widget.reply.reply,
        fontSize: 16,
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
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
      const SizedBox(height: 8),
      widget.reply.stats == null
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
                _onVotePressed(ReplyAction.agree);
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
                _onVotePressed(ReplyAction.disagree);
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
                _onVotePressed(ReplyAction.pass);
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
      : SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            Neapolitan(
              pieces: [
                widget.reply.stats!.agreeCount,
                widget.reply.stats!.passCount,
                widget.reply.stats!.disagreeCount
              ],
              colors: const [Colors.green, Colors.white, Colors.red],
            ),
          ],
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
