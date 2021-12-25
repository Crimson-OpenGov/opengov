import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  const AddComment();

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {});
    });
  }

  int get _remainingCharacters => 140 - _textController.text.length;

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
                        ? () {}
                        : null,
                child: const Text('Submit'),
              ),
            ],
          ),
        ],
      );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
