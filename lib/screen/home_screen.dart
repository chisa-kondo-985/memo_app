import 'package:flutter/material.dart';
import 'package:memo_app/fetch_database.dart';
import 'package:memo_app/model/failure_model.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/screen/create_memo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = FetchDatabase().getItems();
  }

  void _refreshItems() {
    setState(() {
      _futureItems = FetchDatabase().getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo'),
        backgroundColor: const Color.fromARGB(255, 239, 239, 244),
      ),
      body: Column(
        children: [
          const Text('お気に入り'),
          // TODO: ここにお気に入りのメモのみを表示する
          Flexible(
            child: FutureBuilder<List<Item>>(
              future: _futureItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
                      child: Container(
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
                              trailing: const Icon(Icons.add_reaction_rounded),
                              // TODO: メモを編集する画面を作る
                              // https://stackoverflow.com/questions/54228037/can-i-use-ontap-from-listtile-to-go-to-new-screen
                              // onTap: ,
                            );
                          },
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(color: Colors.grey.shade300, height: 2);
                          },
                        ),
                      ));
                } else if (snapshot.hasError) {
                  final failure = snapshot.error as RequestFailure;
                  return Center(child: Text(failure.message));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          const Text('その他'),
          // TODO: ここにお気に入り以外のメモを表示する
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMemoScreen()),
          );
          // 次の画面から前の画面に戻った時にデータベースを読み込み直す
          _refreshItems();
        },
        child: const Icon(
          Icons.note_add,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 239, 244),
    );
  }
}
