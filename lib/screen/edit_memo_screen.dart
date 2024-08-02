import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/update_database.dart';

class EditMemoScreen extends StatefulWidget {
  final Item item;
  const EditMemoScreen({super.key, required this.item});

  @override
  _EditMemoScreenState createState() => _EditMemoScreenState();
}

class _EditMemoScreenState extends State<EditMemoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isChecked;
  late String _pageId;
  late DateTime lastEditedTime;
  late String date;

  @override
  void initState() {
    super.initState();
    // Set memo title and texts saved in the database.
    _titleController = TextEditingController(text: widget.item.title);
    _contentController = TextEditingController(text: widget.item.content);
    // Set checkbox's value.
    _isChecked = widget.item.isChecked;
    // Set item's pageId.
    _pageId = widget.item.pageId;

    // Convert lastEditedTime from DateTime to String.
    lastEditedTime = widget.item.lastEditedTime;
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    date = outputFormat.format(lastEditedTime);
  }

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
        leadingWidth: 120,
        leading: GestureDetector(
          // TODO: 前の画面に戻る時に画面を読み込み直す処理をつけるか考える
          // onTap: _submitForm,
          onTap: () {
            Navigator.of(context).pop(true);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            // TODO: ハートを押したら、お気に入りにできるようにする
            onPressed: () {},
          ),
          // Tap save button, send patch request and update the Notion database.
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final updateDatabase = UpdateDatabase();
              updateDatabase.updateItem(_pageId, _contentController.text, _isChecked, _titleController.text);
            },
          ),
        ],
      ),
      // ===== Application Body =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Edit: $date',
              style: const TextStyle(color: Colors.black26),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 28),
              decoration: InputDecoration.collapsed(
                hintText: 'タイトル',
                hintStyle: TextStyle(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _contentController,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration.collapsed(
                hintText: 'コンテンツ',
                hintStyle: TextStyle(color: Colors.grey.shade300),
              ),
              maxLines: null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                const Text('Checked'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
