import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lets_talk_chat/screens/ChatScreen.dart';
import 'package:lets_talk_chat/screens/ChatScreen1.dart';
import 'package:lets_talk_chat/screens/ChatScreen2.dart';
import 'package:lets_talk_chat/screens/HomeScreen.dart';
import 'package:lets_talk_chat/screens/LoginScreen.dart';
import 'package:lets_talk_chat/screens/SplashScreen.dart';
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
      initialRoute: Routes.start,
      routes: {
        Routes.start:(context) => SplashScreen(),
        Routes.login: (context) => LoginScreen(),
        Routes.chat: (context) => ChatScreen1(),
      },
    );
  }
}