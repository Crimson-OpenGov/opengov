import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_common/actions/add_comment.dart';
import 'package:opengov_common/models/poll.dart';

class AddComment extends StatefulWidget {
  final Poll poll;

  const AddComment({required this.poll});

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
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

  Future<void> _addComment() async {
    final response = await HttpService.addComment(AddCommentRequest(
      pollId: widget.poll.id,
      comment: _textController.text,
    ));

    switch (response?.reason) {
      case null:
      case AddCommentResponseReason.error:
        setState(() {
          _responseMessage =
              'A server error occurred while posting your comment.';
        });
        break;
      case AddCommentResponseReason.curseWords:
        setState(() {
          _responseMessage =
              "Please ensure that your comment doesn't contain any swear "
              "words.";
        });
        break;
      case AddCommentResponseReason.needsApproval:
      case AddCommentResponseReason.approved:
        setState(() {
          _responseMessage = response!.reason ==
                  AddCommentResponseReason.needsApproval
              ? 'Comment sent! Your comment will be displayed to other users '
                  'once it is approved by an admin.'
              : 'Comment sent! Your comment is now visible to other users.';
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
              hintText: 'Share your perspective anonymously...',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.done,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                        ? _addComment
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
