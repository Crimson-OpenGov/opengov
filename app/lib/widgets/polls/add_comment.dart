import 'package:flutter/material.dart';
import 'package:opengov_app/common.dart';
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
  final _textController = TextEditingController();
  var _addedComment = false;

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {});
    });
  }

  int get _remainingCharacters => 140 - _textController.text.length;

  Future<void> _addComment() async {
    final response = await HttpService.addComment(AddCommentRequest(
      pollId: widget.poll.id,
      comment: _textController.text,
    ));

    if (response?.success ?? false) {
      setState(() {
        _textController.clear();
        _addedComment = true;
      });
    } else {
      showMessageDialog(
        context,
        body:
            'An error occurred while posting your comment. Please ensure that '
            "your comment doesn't contain any swear words.",
      );
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Share your perspective...',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
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
                    _remainingCharacters < 140 && _remainingCharacters >= 0
                        ? _addComment
                        : null,
                child: const Text('Submit'),
              ),
            ],
          ),
          if (_addedComment)
            const Text(
                'Comment sent! Other participants will see your comment and '
                'can agree or disagree with it.'),
        ],
      );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
