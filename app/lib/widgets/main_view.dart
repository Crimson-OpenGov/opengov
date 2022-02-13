import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/announcement/announcements_list.dart';
import 'package:opengov_app/widgets/feed/feed_view.dart';
import 'package:opengov_app/widgets/polls/polls_list.dart';

class MainView extends StatefulWidget {
  const MainView();

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          index: _index,
          children: const [PollsList(), FeedView(), AnnouncementsList()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Polls',
              icon: Icon(Icons.poll),
            ),
            BottomNavigationBarItem(
              label: 'Feed',
              icon: Icon(Icons.list),
            ),
            BottomNavigationBarItem(
              label: 'Announcements',
              icon: Icon(Icons.announcement),
            ),
          ],
        ),
      );
}
