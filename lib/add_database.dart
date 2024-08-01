import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AddDatabase {
  static const String _url = 'https://api.notion.com/v1/pages';

  final http.Client _client;

  AddDatabase({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future addItem(String content, String title) async {
    try {
      final response = await _client.post(
        Uri.parse(_url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          // 'parent': {'database_id': '${dotenv.env['NOTION_DATABASE_ID']}'},
          'parent': {'database_id': '17a6e36dbb484ec3a0f6be60f246825f'},
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
        debugPrint('Memo added successfully');
        return true;
      } else {
        debugPrint('Failed to add memo: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint('Exception caught: $error');
      return false;
    }
  }
}
