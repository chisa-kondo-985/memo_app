import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class DatabaseService {
  static const String baseUrl = 'https://api.notion.com/v1';
  final http.Client client;

  DatabaseService({http.Client? client}) : client = client ?? http.Client();

  void dispose() {
    client.close();
  }

  Map<String, String> get headers => {
        HttpHeaders.authorizationHeader: 'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json; charset=UTF-8',
      };
}
