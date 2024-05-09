import 'package:flutter/material.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/http_services.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/utils/helpers/converter.dart';
import 'package:frontend/utils/helpers/functions.dart';

class CustomPaginatedDataTable extends StatefulWidget {
  const CustomPaginatedDataTable({super.key, required this.sheetTitle});

  final String sheetTitle;

  @override
  State<CustomPaginatedDataTable> createState() =>
      _CustomPaginatedDataTableState();
}

class _CustomPaginatedDataTableState extends State<CustomPaginatedDataTable> {
  int _rowsPerPage = 10;
  int _currentPage = 1;
  List<dynamic> _headers = [];
  final Map<int, List<List<dynamic>>> _rows = {};
  bool _isLoading = false;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  static final HttpServices _httpServices = getIt<HttpServices>();

  @override
  void initState() {
    super.initState();
    fetchHeaders();
    fetchData();
  }

  Future<void> fetchHeaders() async {
    try {
      final headers = await _httpServices.getHeaders(widget.sheetTitle);
      setState(() {
        _headers = headers;
      });
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
  }

  Future<void> fetchData() async {
    if (_rows[_currentPage] != null) return;

    setState(() => _isLoading = true);
    final sheetTitle = widget.sheetTitle;
    try {
      List<List<dynamic>> rows =
          (await _httpServices.getRows(sheetTitle, _currentPage, _rowsPerPage))
              .cast<List<dynamic>>();

      // make sure all rows have the same length as the headers
      final headersLength = _headers.length;
      for (List<dynamic> row in rows) {
        final toExtend = (_headers.length - row.length).abs();
        final toExtendIn = List.filled(toExtend, '');
        if (row.length < headersLength) {
          row.addAll(toExtendIn);
        } else if (row.length > headersLength) {
          setState(() => _headers.addAll(toExtendIn));
        }
      }
      // convert the rows to string
      setState(() => _rows[_currentPage] = rows);
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: SizedBox(
                width: double.infinity,
                child: PaginatedDataTable(
                  header: Text(widget.sheetTitle),
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: setRowsPerPage,
                  availableRowsPerPage: const [10, 25, 50],
                  onPageChanged: onPageChanged,
                  showFirstLastButtons: true,
                  onSelectAll: (_) {},
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: headersToColumns(_headers, onSort),
                  source: _DataSource(context, _rows[_currentPage]!),
                )),
          );
  }

  /// Sort the table by the given column index and order of the sort
  ///
  /// [columnIndex] the index of the column to sort by.
  ///
  /// [ascending] the order of the sort.
  onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _rows[_currentPage]!.sort(
          (a, b) => Helpers.compare(a[columnIndex], b[columnIndex], ascending));
    });
  }

  List<DataColumn> headersToColumns(
      List<dynamic> headers, Function(int, bool) onSort) {
    return headers
        .map((header) => DataColumn(
              label: Text(header),
              onSort: onSort,
            ))
        .toList();
  }

  void onPageChanged(int index) async {
    setState(() => _currentPage = index);
    await fetchData();
  }

  void setRowsPerPage(int? value) {
    setState(() => _rowsPerPage = value!);
    _rows.clear();
    fetchData();
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data);

  final BuildContext context;
  final List<List<dynamic>> data;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    return DataRow.byIndex(
        index: index,
        cells: data[index]
            .map((cell) => DataCell(Text(TConverter.valueToString(cell))))
            .toList());
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
