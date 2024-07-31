// lib/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:lets_talk_chat/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _password, _confirmPassword, _email, _phoneNumber, _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
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
    'Create an account',
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
    validator: (value) => value!.isEmpty? 'Please enter a username' : null,
    onSaved: (value) => _username = value!,
    ),
    SizedBox(height: 10),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Email',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.email),
    ),
    validator: (value) => value!.isEmpty? 'Please enter an email' : null,
    onSaved: (value) => _email = value!,
    ),
    SizedBox(height: 10),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Phone Number',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.phone),
    ),
    validator: (value) => value!.isEmpty? 'Please enter a phone number' : null,
    onSaved: (value) => _phoneNumber = value!,
    ),
    SizedBox(height: 10),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Address',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.location_on),
    ),
    validator: (value) => value!.isEmpty? 'Please enter an address' : null,
    onSaved: (value) => _address = value!,
    ),
    SizedBox(height: 10),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
    ),
    obscureText: true,
    validator: (value) => value!.isEmpty? 'Please enter a password' : null,
    onSaved: (value) => _password = value!,
    ),
    SizedBox(height: 10),
    TextFormField(
    decoration: InputDecoration(
    labelText: 'Confirm Password',
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
    ),
    obscureText: true,
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please confirm your password';
    }
    if (value!= _password) {
    return 'Passwords do not match';
    }
    return null;
    },
    onSaved: (value) => _confirmPassword = value!,
    ),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () async {
    if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    // Create user account
    bool isCreated = await createUserAccount(_username, _email, _password, _phoneNumber, _address);
    if (isCreated) {
    // Save user credentials to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _username);
    prefs.setString('password', _password);

    // Navigate to login screen
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to create user account')),
    );
    }
    }
    },
    child: Text('Sign up'),
    style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue
    ),
    ),
    SizedBox(height: 10),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    'Already have an account? ',
    style: TextStyle(
    fontSize: 16,
    color: Colors.grey,
    ),
    ),
    GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    },
    child: Text(
    'Login',
    style: TextStyle(
    fontSize: 16,
      color: Colors.blue,
    ),
    ),
    ),
    ],
    ),
    ],
    ),
    ),
        ),
    );
  }

  Future<bool> createUserAccount(String username, String email, String password, String phoneNumber, String address) async {
    // Implement your user account creation logic here
    // For demonstration purposes, I'll just return true
    return true;
  }
}