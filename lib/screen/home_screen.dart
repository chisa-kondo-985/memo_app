import 'package:flutter/material.dart';
import 'package:memo_app/fetch_database.dart';
import 'package:memo_app/model/failure_model.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/screen/create_memo_screen.dart';
import 'package:memo_app/screen/edit_memo_screen.dart';

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

  // Refresh data from Notion database by using http connection.
  void _refreshItems() {
    setState(() {
      // TODO: 値を更新した後に、futureが再構築されない。リストが更新されない。
      _futurePinnedItems = FetchDatabase().getPinnedItems();
      _futureNormalItems = FetchDatabase().getNormalItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Application Bar =====
      appBar: AppBar(
        title: const Text('Memo'),
        backgroundColor: const Color.fromARGB(255, 239, 239, 244),
      ),
      // ===== Application Body =====
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Pinned Memos ListView =====
            const Text(
              'Pinned',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: FutureBuilder<List<Item>>(
                future: _futurePinnedItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!;
                    // For Debugging
                    debugPrint('FutureBuilder: Data received - ${items.length} items');

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = items[index];
                          // TODO: 左にスワイプしたら、削除できるようにする
                          return ListTile(
                            title: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(item.content),
                            trailing: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            // Tap each ListTile, then open the screen for editing memo.
                            // And after go back to this page, refresh ListView data.
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMemoScreen(item: item),
                                ),
                              );
                              // TODO: 値を更新した後に、futureが再構築されない。リストが更新されない。
                              _refreshItems();
                            },
                          );
                        },
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(color: Colors.grey.shade300, height: 2);
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    final failure = snapshot.error as RequestFailure;
                    // For Debugging
                    debugPrint('FutureBuilder: Error - ${failure.message}');
                    return Center(child: Text(failure.message));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            // ===== Other Memos ListView =====
            const Text(
              'Other',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: FutureBuilder<List<Item>>(
                future: _futureNormalItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!;

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(
                              item.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(item.content),
                            trailing: const Icon(Icons.favorite_border),
                            // Tap each ListTile, then open the screen for editing memo.
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMemoScreen(item: item),
                                ),
                              );
                            },
                          );
                        },
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(color: Colors.grey.shade300, height: 2);
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    final failure = snapshot.error as RequestFailure;

                    return Center(child: Text(failure.message));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // ===== Floating Action Button =====
      floatingActionButton: FloatingActionButton(
        // Tap this floating button, go to the screen for creating the new memo.
        // And after go back to this page, refresh ListView data.
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateMemoScreen(),
            ),
          );
          _refreshItems();
        },
        child: const Icon(
          Icons.note_add,
        ),
      ),
      // ===== App Body's Background Color =====
      backgroundColor: const Color.fromARGB(255, 239, 239, 244),
    );
  }
}
