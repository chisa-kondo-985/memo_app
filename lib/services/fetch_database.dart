import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memo_app/model/response_result.dart';
import 'package:memo_app/model/item_model.dart';
import 'package:memo_app/services/database_service.dart';

class FetchDatabase extends DatabaseService {
  FetchDatabase({super.client});

  // ===== For Pinned Items =====
  Future<List<Item>> getPinnedItems() async {
    final url = '${DatabaseService.baseUrl}/databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
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

        return databaseData;
      } else {
        throw ResponseResult(
          message: 'Status Code is NOT 200',
          debugInfo: 'Status Code: ${response.statusCode}\nError: ${response.body}',
        );
      }
    } catch (error) {
      throw ResponseResult(message: 'Something went wrong!', debugInfo: 'Error: $error');
    }
  }

  // ===== For Normal Items =====
  Future<List<Item>> getNormalItems() async {
    final url = '${DatabaseService.baseUrl}/databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
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

        return databaseData;
      } else {
        throw ResponseResult(
          message: 'Failed to fetch database',
          debugInfo: 'Status Code: ${response.statusCode}\nError: ${response.body}',
        );
      }
    } catch (error) {
      throw ResponseResult(message: 'Something went wrong!', debugInfo: 'Error: $error');
    }
  }
}
