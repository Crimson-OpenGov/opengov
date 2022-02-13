import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/details/comment_card.dart';
import 'package:opengov_common/actions/feed.dart';

class FeedView extends StatefulWidget {
  const FeedView();

  @override
  State<StatefulWidget> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  List<FeedComment>? _comments;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await HttpService.getRandomFeed();

    if (response != null) {
      setState(() {
        _comments = response.comments;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
          elevation: 0,
        ),
        body: _comments == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView(
                  children: [
                    for (final comment in _comments!)
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        child: CommentCard(
                          comment: comment,
                          onActionPressed: () {
                            print('Action pressed');
                          },
                        ),
                      ),
                  ],
                ),
              ),
      );
}
