import 'package:flutter/material.dart';

class BaseMemoScreen extends StatefulWidget {
  const BaseMemoScreen({super.key});

  @override
  BaseMemoScreenState createState() => BaseMemoScreenState();
}

class BaseMemoScreenState extends State<BaseMemoScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController titleController;
  late TextEditingController contentController;

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 100,
        color: Colors.transparent,
        child: const Row(
          children: [
            Icon(
              Icons.navigate_before_rounded,
              color: Colors.amber,
              size: 40,
            ),
            Flexible(
              child: Text(
                'Notes',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return IconButton(
      icon: const Icon(Icons.save, color: Colors.amber),
      onPressed: saveButtonFunction,
    );
  }

  void saveButtonFunction() {}

  List<Widget> memoScreen() {
    return [];
  }

  Widget titleField() {
    return TextFormField(
      controller: titleController,
      style: const TextStyle(fontSize: 28),
      maxLines: null,
      decoration: InputDecoration.collapsed(
        hintText: 'タイトル',
        hintStyle: TextStyle(color: Colors.grey.shade300),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the title';
        }
        return null;
      },
    );
  }

  Widget contentField() {
    return TextFormField(
      controller: contentController,
      style: const TextStyle(fontSize: 16),
      maxLines: null,
      decoration: InputDecoration.collapsed(
        hintText: 'コンテンツ',
        hintStyle: TextStyle(color: Colors.grey.shade300),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Application Bar =====
      appBar: AppBar(
        leadingWidth: 120,
        leading: backButton(),
        actions: <Widget>[
          saveButton(),
        ],
      ),
      // ===== Memo Screen =====
      body: Form(
        key: formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: memoScreen(),
          ),
        ),
      ),
    );
  }
}
