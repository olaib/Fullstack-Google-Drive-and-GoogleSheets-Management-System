<<<<<<< Updated upstream
import 'dart:convert';
import 'package:frontend/utils/logger/logger.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  late final String _serverUrl;

  HttpServices(String? url) : _serverUrl = url ?? 'http://localhost:8000';

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

  Future<dynamic> getSheetContent(String sheetId, String sheetName) async {
    Log.debug('Getting sheet content for $sheetId and $sheetName');
    final response = await http.post(
      Uri.parse(
          '$_serverUrl/sheets'),
      body: jsonEncode({'sheetId': '1jCy8geqAyF1e88xIt1UFIRe6qTPJ5QsxbY3Q9VacHFs', 'sheetName': sheetName}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load sheet content');
=======
// ignore: file_names
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/logger/logger.dart';

class HttpServices {
  HttpServices(this.serverUrl);

  final String serverUrl;

  Future<List<dynamic>> getSheetsTitles() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/sheets'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        Log.debug('Loaded sheets: $data');
        return data;
      } else {
        throw Exception('Failed to load sheets');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<List<dynamic>> getSheetContent(
      {required String sheetId, required String title}) async {
    try {
      final response = await http.get(Uri.parse(
          '$serverUrl/sheets?spreadsheetId=$sheetId&sheetName=$title'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        Log.debug('Loaded sheet content: $data');
        return data;
      } else {
        throw Exception('Failed to load sheet content');
      }
    } catch (e) {
      throw Exception('$e');
>>>>>>> Stashed changes
    }
  }
}
