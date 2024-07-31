import 'package:flutter/material.dart';
import 'package:memo_app/fetch_database.dart';
import 'package:memo_app/model/failure_model.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/screen/new_memo_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo'),
        backgroundColor: const Color.fromARGB(255, 239, 239, 244),
      ),
      body: FutureBuilder<List<Item>>(
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
                  width: 300,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewMemoScreen()),
          );
        },
        child: const Icon(Icons.navigation),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 239, 244),
    );
  }
}
