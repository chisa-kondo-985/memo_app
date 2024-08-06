import 'dart:convert';
import 'package:memo_app/model/response_result.dart';
import 'package:memo_app/services/database_service.dart';

class UpdateDatabase extends DatabaseService {
  UpdateDatabase({super.client});

  Future updateItem(String pageId, String content, bool isChecked, String title) async {
    try {
      final url = '${DatabaseService.baseUrl}/pages/$pageId';
      final response = await client.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          'properties': {
            '内容': {
              'rich_text': [
                {
                  'type': 'text',
                  'text': {'content': content, 'link': null}
                }
              ]
            },
            'チェックボックス': {'type': 'checkbox', 'checkbox': isChecked},
            'タイトル': {
              'type': 'title',
              'title': [
                {
                  'type': 'text',
                  'text': {'content': title, 'link': null}
                }
              ]
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ResponseResult(
          message: 'Failed to update memo',
          debugInfo: 'Status Code: ${response.statusCode}\nError: ${response.body}',
        );
      }
    } catch (error) {
      throw ResponseResult(message: 'Something went wrong!', debugInfo: 'Error: $error');
    }
  }
}
