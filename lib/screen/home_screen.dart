import 'package:flutter/material.dart';
import 'package:memo_app/custom_future_builder.dart';
import 'package:memo_app/fetch_database.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/screen/create_memo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  late Future<List<Item>> _futurePinnedItems;
  late Future<List<Item>> _futureNormalItems;

  // Get data from Notion database by using http connection when app is launch.
  @override
  void initState() {
    super.initState();
    _futurePinnedItems = FetchDatabase().getPinnedItems();
    _futureNormalItems = FetchDatabase().getNormalItems();
  }

  // Update and get data from Notion database by using http connection.
  Future<List<Item>> updateAndGetPinnedItemsList() async {
    return await FetchDatabase().getPinnedItems();
  }

  Future<List<Item>> updateAndGetNormalList() async {
    return await FetchDatabase().getNormalItems();
  }

  // Refresh List items.
  void refreshItems() {
    setState(() {
      _futurePinnedItems = updateAndGetPinnedItemsList();
      _futureNormalItems = updateAndGetNormalList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Application Bar =====
      appBar: AppBar(
        title: const Text(
          'All Memos',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 239, 244),
        toolbarHeight: 70,
      ),
      // ===== Application Body =====
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            // ===== Pinned Memos ListView =====
            CustomFutureBuilder(
              future: _futurePinnedItems,
              refreshItems: refreshItems,
              listTitle: 'Pinned',
              listIcon: const Icon(Icons.favorite, color: Colors.red),
            ),
            const SizedBox(height: 30),
            // ===== Other Memos ListView =====
            CustomFutureBuilder(
              future: _futureNormalItems,
              refreshItems: refreshItems,
              listTitle: 'Other',
              listIcon: const Icon(Icons.favorite_border),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      // ===== Floating Action Button =====
      floatingActionButton: SizedBox(
        width: 80.0,
        height: 80.0,
        child: FloatingActionButton(
          // Tap this floating button, go to the screen for creating the new memo.
          // And wait the process until go back to this page.
          // After go back to this page, refresh ListView data.
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateMemoScreen(),
              ),
            );
            refreshItems();
          },
          foregroundColor: Colors.amber,
          backgroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.note_add, size: 36),
        ),
      ),
      // ===== App Body's Background Color =====
      backgroundColor: const Color.fromARGB(255, 239, 239, 244),
    );
  }
}
