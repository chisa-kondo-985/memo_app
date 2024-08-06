import 'package:flutter/material.dart';
import 'package:memo_app/base/base_memo_screen.dart';
import 'package:memo_app/services/add_database.dart';

class CreateMemoScreen extends BaseMemoScreen {
  const CreateMemoScreen({super.key});

  @override
  _CreateMemoScreenState createState() => _CreateMemoScreenState();
}

class _CreateMemoScreenState extends BaseMemoScreenState {
  // If the form validation is ok, add new memo to Notion database via http connection.
  @override
  void saveButtonFunction() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final addDatabase = AddDatabase();
      addDatabase.addItem(contentController.text, titleController.text);
    }
  }

  @override
  List<Widget> memoScreen() {
    return [
      // ===== Memo body =====
      titleField(),
      const SizedBox(height: 10),
      contentField(),
    ];
  }
}
