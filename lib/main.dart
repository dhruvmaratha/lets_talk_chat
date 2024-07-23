import 'package:flutter/material.dart';
import 'package:lets_talk_chat/screens/ChatScreen.dart';
import 'package:lets_talk_chat/screens/LoginScreen.dart';
import 'package:lets_talk_chat/screens/routes.dart';
import 'package:lets_talk_chat/screens/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Talk',
      themeMode: ThemeMode.system,
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => LoginScreen(),
        Routes.chat: (context) => ChatScreen(),
      },
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
    );
  }
}