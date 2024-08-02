import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UpdateDatabase {
  static const String _baseUrl = 'https://api.notion.com/v1/pages';

  final http.Client _client;

  UpdateDatabase({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future updateItem(String pageId, String content, bool isChecked, String title) async {
    try {
      final url = '$_baseUrl/$pageId';
      final response = await _client.patch(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          'Content-Type': 'application/json; charset=UTF-8',
        },
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
        debugPrint('Memo updated successfully');
        return true;
      } else {
        debugPrint('Failed to update memo: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint('Exception caught: $error');
      return false;
    }
  }
}
