import 'package:flutter/material.dart';
import 'package:memo_app/services/add_database.dart';

class CreateMemoScreen extends StatefulWidget {
  const CreateMemoScreen({super.key});

  @override
  _CreateMemoScreenState createState() => _CreateMemoScreenState();
}

class _CreateMemoScreenState extends State {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Application Bar =====
      appBar: AppBar(
        // ===== Back button =====
        leadingWidth: 120,
        leading: GestureDetector(
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
        ),
        // ===== Save button =====
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final addDatabase = AddDatabase();
                addDatabase.addItem(_contentController.text, _titleController.text);
              }
            },
          ),
        ],
      ),
      // ===== Memo Screen =====
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 28),
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
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _contentController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration.collapsed(
                  hintText: 'コンテンツ',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
