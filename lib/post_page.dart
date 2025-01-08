import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'New Post Page (updated)',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
