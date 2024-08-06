import 'dart:convert';
import 'package:memo_app/model/response_result.dart';
import 'package:memo_app/services/database_service.dart';

class DeleteDatabase extends DatabaseService {
  DeleteDatabase({super.client});

  Future deleteItem(String pageId) async {
    try {
      final url = '${DatabaseService.baseUrl}/pages/$pageId';
      final response = await client.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode({
          'archived': true,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ResponseResult(
          message: 'Failed to delete memo',
          debugInfo: 'Status Code: ${response.statusCode}\nError: ${response.body}',
        );
      }
    } catch (error) {
      throw ResponseResult(message: 'Something went wrong!', debugInfo: 'Error: $error');
    }
  }
}
