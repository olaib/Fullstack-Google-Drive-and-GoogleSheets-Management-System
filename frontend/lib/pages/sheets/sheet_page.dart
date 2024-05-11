import 'package:flutter/material.dart';
import 'package:frontend/features/google_sheets_data/pagenated_data_table/paginated_data_table.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.sheetId, required this.sheetTitle});

  final String? sheetTitle;
  final String? sheetId;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  @override
  void initState() {
    super.initState();
    if (widget.sheetId == null || widget.sheetTitle == null) {
      throw Exception("Sheet ID is required");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaginatedDataTable(sheetTitle: widget.sheetTitle!);
  }
}
