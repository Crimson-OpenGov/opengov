import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:opengov_app/firebase_options.dart';
import 'package:opengov_app/widgets/login/explainer.dart';
import 'package:opengov_app/widgets/polls/polls_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const _crimson = Color(0xFFA51C30);

  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crimson OpenGov',
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: _crimson,
          secondary: _crimson,
          surface: _crimson,
        ),
      ).copyWith(
        timePickerTheme:
            const TimePickerThemeData(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: _crimson,
          surface: _crimson,
        ),
      ).copyWith(
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Color(0xff121212),
        ),
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
          : const Explainer();
}
