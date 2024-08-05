import 'package:flutter/material.dart';
import 'package:memo_app/delete_database.dart';
import 'package:memo_app/model/failure_model.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/update_database.dart';

import 'screen/edit_memo_screen.dart';

class CustomFutureBuilder extends StatelessWidget {
  final Future<List<Item>> future;
  final VoidCallback refreshItems;
  final String listTitle;
  final Widget listIcon;

  const CustomFutureBuilder({
    super.key,
    required this.future,
    required this.refreshItems,
    required this.listTitle,
    required this.listIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data!;
          // For Debugging
          debugPrint('FutureBuilder: Data received - ${items.length} items');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                listTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    return Dismissible(
                      background: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text(
                                  " Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          )),
                      key: ValueKey(item.pageId),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          final res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text("Are you sure you want to delete「${item.title}」?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        final deleteDatabase = DeleteDatabase();
                                        await deleteDatabase.deleteItem(item.pageId);
                                        Navigator.of(context).pop();
                                        refreshItems();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return res;
                        }
                        return null;
                      },
                      child: ListTile(
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(item.content),
                        trailing: IconButton(
                          icon: listIcon,
                          onPressed: () async {
                            final bool isChecked;
                            item.isChecked == true ? isChecked = false : isChecked = true;
                            final updateDatabase = UpdateDatabase();
                            await updateDatabase.updateItem(item.pageId, item.content, isChecked, item.title);
                            refreshItems();
                          },
                        ),
                        // Tap each ListTile, then open the screen for editing memo.
                        // And wait the process until go back to this page.
                        // After go back to this page, refresh ListView data.
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMemoScreen(item: item),
                            ),
                          );
                          refreshItems();
                        },
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(color: Colors.grey.shade300, height: 2);
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          final failure = snapshot.error as RequestFailure;
          return Center(child: Text(failure.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
