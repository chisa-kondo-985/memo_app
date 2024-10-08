import 'package:flutter/material.dart';
import 'package:memo_app/services/delete_database.dart';
import 'package:memo_app/model/response_result.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/services/update_database.dart';
import '../screen/edit_memo_screen.dart';

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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ===== List View Title =====
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  listTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Decide the list design.
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                // ===== Memo List View =====
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(color: Colors.grey.shade300, height: 2);
                  },
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    // If the user swap each list tile from right to left, The confirming alert will appear.
                    // The user answer "Delete", then delete the data from Notion database.
                    // The user answer "Cancel", then go back to the home screen.
                    return Dismissible(
                      // ===== Swap listTile Background =====
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
                                  "Delete",
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
                      // Notion database page is unique key for Dismissible class.
                      key: ValueKey(item.pageId),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          final result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // ===== Swap listTile Dialog =====
                                return AlertDialog(
                                  content: Text("Are you sure you want to delete「${item.title}」?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black87),
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
                                        Navigator.of(context).pop();
                                        final deleteDatabase = DeleteDatabase();
                                        await deleteDatabase.deleteItem(item.pageId);
                                        refreshItems();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return result;
                        }
                        return null;
                      },
                      // ===== Memo List Tile =====
                      child: ListTile(
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          item.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Tap the heart icon, change the checkbox status.
                        // And update the data in the Notion database and refresh memo lists.
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
                        // Tap each List Tile, then open the screen for editing memo.
                        // And wait the process until go back to home screen.
                        // After go back to home screen, refresh ListView data.
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditMemoScreen(item: item)),
                          );
                          refreshItems();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
          // If some error occur, show the message and debug info.
        } else if (snapshot.hasError) {
          final failure = snapshot.error as ResponseResult;
          return Column(children: [Text(failure.message), Text(failure.debugInfo)]);
          // Show the circular progress indicator.
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
