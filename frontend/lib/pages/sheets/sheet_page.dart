import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_loading_indicator.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/HttpServices.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/utils/logger/logger.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.sheetId, required this.sheetTitle});

  final String? sheetTitle;
  final String? sheetId;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  static final HttpServices _httpServices = getIt<HttpServices>();
  List<dynamic> _headers = [];
  List<List<dynamic>> _rows = [];

  bool isLoading = false;

  void loadSheetContent() async {
    try {
      setState(() => isLoading = true);
      List<dynamic> sheetContent = await _httpServices.getSheetContent(
          widget.sheetId!, widget.sheetTitle!);
      setState(() {
        if (sheetContent.isEmpty) {
          throw Exception("No data found");
        }
        _headers = sheetContent[0] ?? [];
        Log.debug(_headers);
        _rows = sheetContent
            .sublist(1)
            .map((row) => [
                  ...row,
                  if (row.length < _headers.length)
                    ...List.filled((_headers.length - row.length).toInt(), "")
                ])
            .toList();
        Log.debug(_rows);
      });
    } catch (e) {
      Log.error(e.toString());
      AppMethods.showErrorMessage(context, e.toString());
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    if (widget.sheetId == null || widget.sheetTitle == null) {
      throw Exception("Sheet ID is required");
    }
    loadSheetContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CustomLoadingIndicator())
          : Column(
              children: [
                Text(
                  widget.sheetTitle ?? 'Default Title',
                  style: Theme.of(context).textTheme.headline4,
                ),
                DataTable(
                  columns: _headers
                      .map<DataColumn>((header) =>
                          DataColumn(label: Text(header.toString())))
                      .toList(),
                  rows: _rows.map<DataRow>((row) {
                    return DataRow(
                      cells: row
                          .map<DataCell>(
                              (cell) => DataCell(Text(cell.toString())))
                          .toList(),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
