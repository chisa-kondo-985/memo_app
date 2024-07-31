class Item {
  final DateTime createdTime;
  final DateTime lastEditedTime;
  final String title;
  final String content;
  final String checkboxId;
  final bool isChecked;

  const Item({
    required this.createdTime,
    required this.lastEditedTime,
    required this.title,
    required this.content,
    required this.checkboxId,
    required this.isChecked,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    return Item(
      createdTime: DateTime.parse(map['created_time']),
      lastEditedTime: DateTime.parse(map['last_edited_time']),
      title: properties['タイトル']?['title']?[0]?['plain_text'] ?? '',
      content: properties['内容']?['rich_text']?[0]?['plain_text'] ?? '',
      checkboxId: properties['チェックボックス']?['id'],
      isChecked: properties['チェックボックス']?['checkbox'] ?? '',
    );
  }
}
