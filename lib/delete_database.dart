import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeleteDatabase {
  static const String _baseUrl = 'https://api.notion.com/v1/pages';

  final http.Client _client;

  DeleteDatabase({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future deleteItem(String pageId) async {
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
          'parent': {'database_id': '${dotenv.env['NOTION_DATABASE_ID']}'},
          'archived': true,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Memo deleted successfully');
        return true;
      } else {
        debugPrint('Failed to delete memo: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint('Exception caught: $error');
      return false;
    }
  }
}
