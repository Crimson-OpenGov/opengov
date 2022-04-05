import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/polls/details/reply_card.dart';
import 'package:opengov_common/models/reply.dart';

class ReplyList extends StatefulWidget {
  final List<ReplyBase> replies;
  final void Function(int i) onActionPressed;

  const ReplyList({required this.replies, required this.onActionPressed});

  @override
  State<StatefulWidget> createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.replies.isEmpty
      ? const Text('No more replies.')
      : Column(
          children: [
            for (var i = 0; i < widget.replies.length; i++)
              Padding(
                padding: i < widget.replies.length - 1
                    ? const EdgeInsets.only(bottom: 8)
                    : EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ReplyCard(
                    reply: widget.replies[i],
                    onActionPressed: () {
                      widget.onActionPressed(i);
                    },
                  ),
                ),
              ),
          ],
        );
}
