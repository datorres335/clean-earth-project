import 'package:clean_earth_project2/login_page.dart';
import 'package:clean_earth_project2/post_page.dart';
import 'package:clean_earth_project2/user_profile_posts.dart';
import 'package:flutter/material.dart';
import 'package:clean_earth_project2/search_page.dart';
import 'package:clean_earth_project2/saved_page.dart';
import 'package:clean_earth_project2/profile_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //NEED THIS FOR THE API KEY LOCATED IN .env
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(); //NEED THIS FOR THE API KEY LOCATED IN .env

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Earth Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

// Wrapper widget to handle user authentication
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading indicator while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If the user is logged in, redirect to the main home page
        if (snapshot.hasData) {
          return const MyHomePage();
        }

        // If the user is not logged in, show the login page
        return const LoginPage();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    const SearchPage(),
    const PostPage(),
    const SavedPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    _currentIndex = (_currentIndex >= _pages.length) ? 0 : _currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
