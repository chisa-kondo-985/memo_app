import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:memo_app/model/failure_model.dart';
import 'package:memo_app/model/item_model.dart';

class FetchDatabase {
  static const String _baseUrl = 'https://api.notion.com/v1';

  final http.Client _client;

  FetchDatabase({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<List<Item>> getPinnedItems() async {
    try {
      final url = '$_baseUrl/databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'filter': {
            'property': 'チェックボックス',
            'checkbox': {'equals': true}
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        List<Item> databaseData = [];

        for (var value in responseData['results']) {
          databaseData.add(Item.fromMap(value));
        }

        // For Debugging
        debugPrint('getPinnedItems: Response received');
        return databaseData;
      } else {
        // For Debugging
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        throw const RequestFailure(message: 'Status Code is NOT 200');
      }
    } catch (error) {
      // For Debugging
      debugPrint('Exception caught: $error');

      throw const RequestFailure(message: 'Something went wrong!');
    }
  }

  Future<List<Item>> getNormalItems() async {
    try {
      final url = '$_baseUrl/databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2022-06-28',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'filter': {
            'property': 'チェックボックス',
            'checkbox': {'equals': false}
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        List<Item> databaseData = [];

        for (var value in responseData['results']) {
          databaseData.add(Item.fromMap(value));
        }

        // For Debugging
        debugPrint('getNormalItems: Response received');
        return databaseData;
      } else {
        // For Debugging
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        throw const RequestFailure(message: 'Status Code is NOT 200');
      }
    } catch (error) {
      // For Debugging
      debugPrint('Exception caught: $error');

      throw const RequestFailure(message: 'Something went wrong!');
    }
  }
}
