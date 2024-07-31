import 'package:flutter/material.dart';

class NewMemoScreen extends StatefulWidget {
  const NewMemoScreen({super.key});

  @override
  _NewMemoScreenState createState() => _NewMemoScreenState();
}

class _NewMemoScreenState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Memo'),
      ),
      body: Text('a'),
    );
  }
}
