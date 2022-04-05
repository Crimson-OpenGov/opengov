import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/actions/add_reply.dart';
import 'package:opengov_common/models/poll.dart';
import 'package:opengov_common/models/comment.dart';


class AddReply extends StatefulWidget {
  final Comment comment;

  const AddReply({required this.comment});

  @override
  _AddReplyState createState() => _AddReplyState();
}

class _AddReplyState extends State<AddReply> {
  static const _limit = 420;

  final _textController = TextEditingController();
  String? _responseMessage;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {});
    });
  }

  int get _remainingCharacters => _limit - _textController.text.length;

  Future<void> _addReply() async {
    final response = await HttpService.addReply(AddReplyRequest(
      commentId: widget.comment.id,
      reply: _textController.text,
    ));

    switch (response?.reason) {
      case null:
      case AddReplyResponseReason.error:
        setState(() {
          _responseMessage =
              'A server error occurred while posting your comment.';
        });
        break;
      case AddReplyResponseReason.curseWords:
        setState(() {
          _responseMessage =
              "Please ensure that your comment doesn't contain any swear "
              "words.";
        });
        break;
      case AddReplyResponseReason.needsApproval:
      case AddReplyResponseReason.approved:
        setState(() {
          _responseMessage = response!.reason ==
                  AddReplyResponseReason.needsApproval
              ? 'Reply sent! Your comment will be displayed to other users '
                  'once it is approved by an admin.'
              : 'Reply sent! Your comment is now visible to other users.';
          _textController.clear();
        });
        if (await InAppReview.instance.isAvailable()) {
          InAppReview.instance.requestReview();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Reply to this comment anonymously...',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            textInputAction: TextInputAction.done,
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your reply will appear in other people’s feeds',// to be '
                  //'voted on.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_remainingCharacters',
                style: TextStyle(
                    color:
                        _remainingCharacters >= 0 ? Colors.grey : Colors.red),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed:
                    _remainingCharacters < _limit && _remainingCharacters >= 0
                        ? _addReply
                        : null,
                child: const Text('Submit'),
              ),
            ],
          ),
          if (_responseMessage != null) Text(_responseMessage!),
        ],
      );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
