import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memo_app/model/response_result.dart';
import 'package:memo_app/services/database_service.dart';

class AddDatabase extends DatabaseService {
  AddDatabase({super.client});

  Future addItem(String content, String title) async {
    const url = '${DatabaseService.baseUrl}/pages';
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          'parent': {'database_id': '${dotenv.env['NOTION_DATABASE_ID']}'},
          'properties': {
            '内容': {
              'rich_text': [
                {
                  'type': 'text',
                  'text': {'content': content, 'link': null}
                }
              ]
            },
            'チェックボックス': {'type': 'checkbox', 'checkbox': false},
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
          message: 'Failed to add memo',
          debugInfo: 'Status Code: ${response.statusCode}\nError: ${response.body}',
        );
      }
    } catch (error) {
      throw ResponseResult(message: 'Something went wrong!', debugInfo: 'Error: $error');
    }
  }
}
