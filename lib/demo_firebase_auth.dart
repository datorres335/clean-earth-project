import 'package:flutter/material.dart';

class DemoFirebaseAuthPage extends StatefulWidget {
  const DemoFirebaseAuthPage({super.key});

  @override
  State<DemoFirebaseAuthPage> createState() => _DemoFirebaseAuthPageState();
}

class _DemoFirebaseAuthPageState extends State<DemoFirebaseAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo UI - TextField"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(),
            TextField(),
            TextButton(onPressed: (){}, child: Text("data")),
            TextButton(onPressed: (){}, child: Text("data"))
          ],
        ),
      ),
    );
  }
}
