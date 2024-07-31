import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;
  final String name;
  final String profilePhoto;

  User({required this.id, required this.name, required this.profilePhoto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      profilePhoto: json['profilePhoto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profilePhoto': profilePhoto,
    };
  }
}

class Chat {
  final String id;
  final String userId;
  final String message;
  final DateTime timestamp;

  Chat({required this.id, required this.userId, required this.message, required this.timestamp});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId: json['userId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ChatScreen1 extends StatefulWidget {
  const ChatScreen1({super.key});

  @override
  State<ChatScreen1> createState() => _ChatScreen1State();
}

class _ChatScreen1State extends State<ChatScreen1> {
  final _storage = const FlutterSecureStorage();
  final TextEditingController _messageController = TextEditingController();
  List<User> _users = [
    User(
      id: 'user1',
      name: 'Jason Martins',
      profilePhoto: 'https://picsum.photos/200/300',
    ),
    User(
      id: 'user2',
      name: 'Het Rathod',
      profilePhoto: 'https://picsum.photos/200/301',
    ),
    User(
      id: 'user3',
      name: 'Dhruv Medatiya',
      profilePhoto: 'https://picsum.photos/200/302',
    ),
    User(
      id: 'user4',
      name: 'Krinal Satasiya',
      profilePhoto: 'https://picsum.photos/200/303',
    ),
    User(
      id: 'user5',
      name: 'Vidhi Shah',
      profilePhoto: 'https://picsum.photos/200/304',
    ),
    User(
      id: 'user6',
      name: 'Ayush Khant',
      profilePhoto: 'https://picsum.photos/200/305',
    ),
  ];
  List<Chat> _chats = [
    Chat(
      id: 'chat1',
      userId: 'user1',
      message: 'Hello, how are you?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Chat(
      id: 'chat2',
      userId: 'user2',
      message: 'I\'m good, thanks! How about you?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Chat(
      id: 'chat3',
      userId: 'user3',
      message: 'What\'s up?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    Chat(
      id: 'chat4',
      userId: 'user4',
      message: 'Not much, just chillin\'',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Chat(
      id: 'chat5',
      userId: 'user5',
      message: 'Hey, what\'s going on?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Chat(
      id: 'chat6',
      userId: 'user6',
      message: 'Not much, just studying',
      timestamp: DateTime.now(),
    ),
  ];

  Future<void> _saveChats() async {
    final chatsJson = _chats.map((chat) => chat.toJson()).toList();
    await _storage.write(key: 'chats', value: jsonEncode(chatsJson));
  }

  Future<void> _loadChats() async {
    final chatsJson = await _storage.read(key: 'chats');
    if (chatsJson != null) {
      final chats = jsonDecode(chatsJson).map((json) => Chat.fromJson(json)).toList();
      setState(() {
        _chats = chats;
      });
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final chat = Chat(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user1',
        message: message,
        timestamp: DateTime.now(),
      );
      _chats.add(chat);
      _messageController.clear();
      setState(() {});
      _saveChats();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  String _formatTimestamp(DateTime timestamp) {
    int hour = timestamp.hour;
    String amPm = hour < 12 ? 'AM' : 'PM';
    if (hour > 12) {
      hour = hour - 12;
    } else if (hour == 0) {
      hour = 12;
    }
    return '${hour}:${timestamp.minute.toString().padLeft(2, '0')} $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Talk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(_users, _chats),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              accountName: Text('Dhruv Maratha'),
              accountEmail: Text('dhruvmaratha21@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200/300'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                // Clear the Flutter Secure Storage
                final storage = FlutterSecureStorage();
                await storage.deleteAll();

                // Navigate to the login page
                Navigator.of(context).pushReplacementNamed('/login');

                // Show a snackbar to indicate that the user has been logged out
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You have been logged out'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                final user = _users.firstWhere((user) => user.id == chat.userId);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePhoto),
                  ),
                  title: Text(user.name),
                  subtitle: Text('${chat.message}'),
                 trailing : Text('${_formatTimestamp(chat.timestamp)}')
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   IconButton(onPressed: () {
              
                    }, icon: Icon(Icons.chat_rounded),iconSize: 30,),
                  IconButton(onPressed: () {
              
                  }, icon: Icon(Icons.contacts_rounded),iconSize: 30,),
                  IconButton(onPressed: () {
              
                  }, icon: Icon(Icons.settings_outlined),iconSize: 30,)
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ChatSearchDelegate extends SearchDelegate {
  final List<User> _users;
  final List<Chat> _chats;

  ChatSearchDelegate(this._users, this._chats);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _chats
        .where((chat) => chat.message.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        final user = _users.firstWhere((user) => user.id == chat.userId);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profilePhoto),
          ),
          title: Text(user.name),
          subtitle: Text(chat.message),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _users
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final user = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profilePhoto),
          ),
          title: Text(user.name),
        );
      },
    );
  }
}