import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// GoogleSignIn instance
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/calendar.readonly',
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign-In Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Google Sign-In Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleSignInAccount? _currentUser;
  String _calendarResponse = '';

  Future<void> _handleSignIn() async {
    try {
      print('Attempting to sign in...');
      final account = await _googleSignIn.signIn();

      if (account == null) {
        setState(() {
          _calendarResponse = 'User cancelled sign-in or sign-in failed.';
        });
        return;
      }

      final auth = await account.authentication;

      if (auth.accessToken == null) {
        setState(() {
          _calendarResponse = 'No access token retrieved.';
        });
        return;
      }

      final token = auth.accessToken!;
      final uri = Uri.parse("http://172.20.10.2:8000/get-calendar/?token=$token");

      final response = await http.get(uri);

      setState(() {
        _currentUser = account;
        _calendarResponse = response.body;
      });
    } catch (error) {
      print("Google Sign-In Error: $error");
      setState(() {
        _calendarResponse = 'Error: $error';
      });
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
      _calendarResponse = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: user == null
            ? ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Sign in with Google"),
          onPressed: _handleSignIn,
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl ?? ''),
                radius: 40,
              ),
              const SizedBox(height: 16),
              Text('Signed in as: ${user.displayName ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.titleLarge),
              Text(user.email),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Sign out"),
                onPressed: _handleSignOut,
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text("Calendar API Response:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                _calendarResponse,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
