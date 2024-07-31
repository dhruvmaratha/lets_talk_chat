import 'package:flutter/material.dart';
import 'package:lets_talk_chat/screens/ChatScreen1.dart';
import 'package:lets_talk_chat/screens/HomeScreen.dart';
import 'package:lets_talk_chat/screens/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _password;
  bool _obscureText = true;
  bool _rememberMe = false;

  final FacebookLogin facebookLogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Let\'s Talk'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
        padding: const EdgeInsets.all(20.0),
    child: Form(
    key: _formKey,
    child: Column(
    children: [
    SizedBox(height: 20),
    Text(
    'Welcome to Let\'s Talk!',
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    ),
    ),
    SizedBox(height: 20),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Username',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.person),
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter a username';
    }
    return null;
    },
    onSaved: (value) => _username = value!,
    ),
    SizedBox(height: 10),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
    suffixIcon: IconButton(
    icon: Icon(_obscureText? Icons.visibility_off : Icons.visibility),
    onPressed: () {
    setState(() {
    _obscureText =!_obscureText;
    });
    },
    ),
    ),
    obscureText: _obscureText,
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter a password';
    }
    return null;
    },
    onSaved: (value) => _password = value!,
    ),
    SizedBox(height: 10),
    CheckboxListTile(
    title: Text('Remember Me'),
    value: _rememberMe,
    onChanged: (value) {
    setState(() {
    _rememberMe = value!;
    });
    },
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () async {
    if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    // Authenticate user
    bool isAuthenticated = await authenticateUser(_username, _password);
    if (isAuthenticated) {
    // Save user credentials to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username);
    prefs.setString('password', _password);

    // Navigate to chat screen
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ChatScreen1()),
    );
    } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Invalid username or password')),
    );
    }
    }
    },
    child: Text('Login'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue[800],
    ),
    ),
    SizedBox(height: 10),
    Text(
    'Don\'t have an account? Sign up now!',
    style: TextStyle(
    fontSize: 16,
    color: Colors.grey,
    ),
    ),
    SizedBox(height: 10),
    ElevatedButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
    },
    child: Text('Sign up'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue[800],
    ),
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () async {
    final FacebookLoginResult result =
    await facebookLogin.logIn(customPermissions: ['email']);
    switch (result.status) {
    case FacebookLoginStatus.success:
    // Login successful
    break;
    case FacebookLoginStatus.cancel:
    // Login cancelled by user
    break;
    case FacebookLoginStatus.error:
    // Login error
    break;
    }
    },
    child: Text('Login with Facebook'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue,
    ),
    ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () async {
          final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn();
          final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
          // Login successful
        },
        child: Text('Login with Google'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.red,
        ),
      ),
      SizedBox(height: 10),
      TextButton(
        onPressed: () {
          // Implement password reset functionality
        },
        child: Text('Forgot Password'),
      ),
    ],
    ),
    ),
        ),
    );
  }

  Future<bool> authenticateUser(String username, String password) async {
    // Implement authentication logic here
    // For now, just return true if the username and password are not empty
    return username.isNotEmpty && password.isNotEmpty;
  }
}