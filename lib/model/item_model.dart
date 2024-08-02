class Item {
  final String pageId;
  final DateTime lastEditedTime;
  final String title;
  final String content;
  final String checkboxId;
  final bool isChecked;

  const Item({
    required this.pageId,
    required this.lastEditedTime,
    required this.title,
    required this.content,
    required this.checkboxId,
    required this.isChecked,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    return Item(
      pageId: map['id'],
      lastEditedTime: DateTime.parse(map['last_edited_time']),
      title: properties['タイトル']?['title']?[0]?['text']?['content'] ?? '',
      content: properties['内容']?['rich_text']?[0]?['text']?['content'] ?? '',
      checkboxId: properties['チェックボックス']?['id'],
      isChecked: properties['チェックボックス']?['checkbox'],
    );
  }
}
