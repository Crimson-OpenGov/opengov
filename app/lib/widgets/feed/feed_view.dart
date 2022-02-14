import 'package:flutter/material.dart';
import 'package:opengov_app/service/http_service.dart';
import 'package:opengov_app/widgets/polls/details/comment_list.dart';
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

  Future<void> _fetchComment(int i) async {
    final response = await HttpService.getCommentDetails(_comments![i]);

    if (response != null) {
      setState(() {
        _comments![i] = _comments![i].copyWith(stats: response.stats);
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: CommentList(
                    comments: _comments!,
                    onActionPressed: _fetchComment,
                  ),
                ),
              ),
      );
}
