import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo_app/base/base_memo_screen.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/services/update_database.dart';

class EditMemoScreen extends BaseMemoScreen {
  final Item item;
  const EditMemoScreen({super.key, required this.item});

  @override
  _EditMemoScreenState createState() => _EditMemoScreenState();
}

class _EditMemoScreenState extends BaseMemoScreenState {
  late bool _isChecked;
  late String _pageId;
  late String _date;

  @override
  void initState() {
    super.initState();
    // Set memo title and texts which were saved in the database.
    titleController = TextEditingController(text: (widget as EditMemoScreen).item.title);
    contentController = TextEditingController(text: (widget as EditMemoScreen).item.content);
    // Set checkbox's value.
    _isChecked = (widget as EditMemoScreen).item.isChecked;
    // Set item's pageId.
    _pageId = (widget as EditMemoScreen).item.pageId;

    // Convert lastEditedTime from DateTime to String.
    final DateTime lastEditedTime = (widget as EditMemoScreen).item.lastEditedTime;
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    _date = outputFormat.format(lastEditedTime);
  }

  // If the form validation is ok, update this memo to Notion database via http connection.
  @override
  void saveButtonFunction() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final updateDatabase = UpdateDatabase();
      updateDatabase.updateItem(_pageId, contentController.text, _isChecked, titleController.text);
    }
  }

  @override
  List<Widget> memoScreen() {
    return [
      // ===== Last Edit Date =====
      Text('Last Edit: $_date', style: const TextStyle(color: Colors.black26)),
      const SizedBox(height: 4),
      // ===== Memo body =====
      titleField(),
      const SizedBox(height: 10),
      contentField(),
    ];
  }
}
