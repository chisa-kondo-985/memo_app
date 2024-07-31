import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenCupertino extends StatelessWidget {
  HomeScreenCupertino({super.key});

  final List<String> notes = [
    'Note 1',
    'Note 2',
    'Note 3',
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Card(
        color: CupertinoColors.white,
        child: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            leading: Text('Memo'),
            backgroundColor: CupertinoColors.extraLightBackgroundGray,
            border: Border(bottom: BorderSide(color: CupertinoColors.extraLightBackgroundGray)),
          ),
          child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (content, index) {
              return CupertinoListTile.notched(
                  title: Text(notes[index]),
                  onTap: () {
                    // Handle tap event, e.g., navigate to note details
                  });
            },
          ),
        ),
      ),
      color: CupertinoColors.extraLightBackgroundGray,
      debugShowCheckedModeBanner: false,
    );
  }
}
