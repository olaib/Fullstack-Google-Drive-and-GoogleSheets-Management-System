import 'dart:convert';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  late final String _serverUrl;

  HttpServices(String? url) : _serverUrl = url ?? SERVER_URL;

  Future<List<dynamic>> getSheetsTitles() async {
    final response = await http.get(Uri.parse(
        '$_serverUrl/sheets/titles?spreadsheetId=1jCy8geqAyF1e88xIt1UFIRe6qTPJ5QsxbY3Q9VacHFs'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load sheets');
    }
  }

  Future<List<dynamic>> getSheetContent(
      String sheetId, String sheetName) async {
    Log.debug('Getting sheet content for $sheetId and $sheetName');
    final response = await http.get(
      Uri.parse(
          '$_serverUrl/sheets?spreadsheetId=1jCy8geqAyF1e88xIt1UFIRe6qTPJ5QsxbY3Q9VacHFs&sheetName=$sheetName'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Log.debug('Sheet content: $data');
      return data;
    } else {
      throw Exception('Failed to load sheet content');
    }
  }
}
