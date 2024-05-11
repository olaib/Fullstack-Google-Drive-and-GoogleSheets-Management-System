import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/helpers/converter.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/storage/preference_utils.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  late final String _serverUrl;
  //todo use change notifier later
  String _spreadsheetId = '';

  HttpServices(String url) : _serverUrl = url;

  void get syncSpreadsheetId => _loadSpreadsheetId();

  void _loadSpreadsheetId() {
    final spreetSheetId = PreferenceUtils.getString(SPREADSHEET_ID_KEY);
    if (spreetSheetId.isEmpty) {
      throw Exception('Spreadsheet id not found please set it in the settings');
    }
    _spreadsheetId = spreetSheetId;
  }

  Future<http.Response> status(http.Response response) async {
    try {
      if (200 <= response.statusCode && response.statusCode < 300) {
        return response;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Log.error(e.toString());
      throw Exception(e.toString());
    }
  }

  dynamic json(http.Response response) {
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getSheetsTitles() async {
    _loadSpreadsheetId();
    return await http
        .get(Uri.parse(
            '$_serverUrl/sheets/titles?spreadsheetId=$_spreadsheetId'))
        .then(status)
        .then(json)
        .then((data) => data);
  }

  Future<List<dynamic>> getRows(
      String sheetName, int currentPage, int rowsPerPage) async {
    _loadSpreadsheetId();
    final data = await http
        .get(
          Uri.parse(
              '$_serverUrl/sheets?spreadsheetId=$_spreadsheetId&sheetName=$sheetName&range=${TConverter.range(currentPage, rowsPerPage)}'),
          headers: JSON_HEADERS,
        )
        .then(status)
        .then(json)
        .then((data) => data);
    return data;
  }

  Future<List<dynamic>> getHeaders(String sheetName) async {
    _loadSpreadsheetId();
    return await http
        .get(
          Uri.parse(
              '$_serverUrl/sheets?spreadsheetId=$_spreadsheetId&sheetName=$sheetName&range=$HEADERS_RANGE'),
          headers: JSON_HEADERS,
        )
        .then(status)
        .then(json)
        .then((data) => data[0]);
  }

  Future<void> updateRow(
      String sheetTitle, List<dynamic> data, int index) async {
    _loadSpreadsheetId();
    await http
        .post(Uri.parse('$_serverUrl/sheets/update'),
            headers: JSON_HEADERS,
            body: jsonEncode({
              'spreadsheetId': _spreadsheetId,
              'sheetName': sheetTitle,
              'data': data.map((e) => e.toString()).toList(),
              'range': '${index + 1}:${index + 1}'
            }))
        .then(status)
        .then(json)
        .then((data) => data);
  }

  Future<void> updateSheetTitle(int sheetId, String title) async {
    _loadSpreadsheetId();
    await http
        .post(Uri.parse('$_serverUrl/sheets/update/title'),
            headers: JSON_HEADERS,
            body: jsonEncode({
              'spreadsheetId': _spreadsheetId,
              'sheetId': sheetId,
              'title': title,
            }))
        .then(status)
        .then((data) => data);
  }

  Future<void> deleteRow(String sheetTitle, int index) async {
    _loadSpreadsheetId();
    await http
        .delete(Uri.parse('$_serverUrl/sheets/row'),
            headers: JSON_HEADERS,
            body: jsonEncode({
              'spreadsheetId': _spreadsheetId,
              'sheetName': sheetTitle,
              'rowNumber': index + 1, //skip headers
            }))
        .then(status)
        .then(json)
        .then((data) => data);
  }

  Future<void> addRow(String sheetTitle, List<dynamic> row, int rowNumber) {
    _loadSpreadsheetId();
    return http
        .post(Uri.parse('$_serverUrl/sheets/append'),
            headers: JSON_HEADERS,
            body: jsonEncode({
              'spreadsheetId': _spreadsheetId,
              'sheetName': sheetTitle,
              'data': row.map((e) => e.toString()).toList(),
              'range': '${rowNumber + 1}:${rowNumber + 1}'
            }))
        .then(status)
        .then(json)
        .then((data) => data);
  }

  Future<void> createSheet(String sheetTitle) async {
    _loadSpreadsheetId();
    await http
        .post(Uri.parse('$_serverUrl/sheets/create'),
            headers: JSON_HEADERS,
            body: jsonEncode({
              'spreadsheetId': _spreadsheetId,
              'sheetName': sheetTitle,
            }))
        .then(status)
        .then(json)
        .then((data) => data);
  }
}
