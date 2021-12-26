import 'package:flutter/material.dart';
import 'package:opengov_app/widgets/login/login_view.dart';
import 'package:opengov_app/widgets/polls/polls_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool? _loggedIn;

  @override
  void initState() {
    super.initState();
    _fetchSharedPreferences();
  }

  Future<void> _fetchSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      _loggedIn = sharedPreferences.containsKey('username') &&
          sharedPreferences.containsKey('token');
    });
  }

  @override
  Widget build(BuildContext context) => _loggedIn == null
      ? const Scaffold()
      : _loggedIn!
          ? const PollsList()
          : const LoginView();
}
