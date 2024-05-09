import 'dart:convert' show jsonDecode;
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/helpers/converter.dart';
import 'package:frontend/utils/logger/logger.dart';
import 'package:frontend/utils/storage/preference_utils.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  late final String _serverUrl;
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
      if (response.statusCode == 200) {
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
}
