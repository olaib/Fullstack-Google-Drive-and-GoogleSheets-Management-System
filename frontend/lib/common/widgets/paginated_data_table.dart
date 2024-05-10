import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/injection_container.dart';
import 'package:frontend/services/http_services.dart';
import 'package:frontend/services/methods.dart';
import 'package:frontend/utils/constants/colors.dart';
import 'package:frontend/utils/constants/constants.dart';
import 'package:frontend/utils/constants/sizes.dart';
import 'package:frontend/utils/helpers/functions.dart';
import 'package:frontend/utils/logger/logger.dart';

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
  final ValueNotifier<bool> _isAllSelected = ValueNotifier<bool>(false);
  List<bool> _isSelected = [];
  int _selectedRow = -1;

  static final HttpServices _httpServices = getIt<HttpServices>();

  @override
  void initState() {
    super.initState();
    fetchData(isFetchingHeaders: true);
  }

  Future<List<dynamic>> fetchHeaders() async {
    final headers = await _httpServices.getHeaders(widget.sheetTitle).onError(
        (error, stackTrace) =>
            AppMethods.showErrorMessage(context, error.toString()));
    return headers;
  }

  Future<void> fetchData({bool isFetchingHeaders = false}) async {
    if (_rows[_currentPage] != null) return;

    setState(() => _isLoading = true);
    try {
      List<List<dynamic>> rows = (await _httpServices.getRows(
              widget.sheetTitle, _currentPage, _rowsPerPage))
          .cast<List<dynamic>>();
      List<dynamic> headers = [];
      if (isFetchingHeaders) {
        headers = await fetchHeaders();
      }
      headers = isFetchingHeaders ? headers : _headers;

      // make sure all rows have the same length as the headers
      final headersLength = headers.length;
      rows.forEach((row) {
        final toExtend = (headers.length - row.length).abs();
        final toExtendIn = List.filled(toExtend, '');
        if (row.length < headersLength) {
          row.addAll(toExtendIn);
        } else if (row.length > headersLength) {
          setState(() => headers.addAll(toExtendIn));
        }
      });
      setState(() {
        _rows[_currentPage] = rows;
        _headers = headers;
        _isSelected.clear();
        _isSelected.addAll(List.filled(_rows[_currentPage]!.length, false));
      });
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
            scrollDirection: Axis.vertical,
            child: SizedBox(
                width: double.infinity,
                child: PaginatedDataTable(
                  showCheckboxColumn: false,
                  onSelectAll: onSelectAll,
                  header: TitleText(widget.sheetTitle, fontSize: FONT_LG),
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: setRowsPerPage,
                  availableRowsPerPage: const [10, 25, 50],
                  onPageChanged: onPageChanged,
                  showFirstLastButtons: true,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  // refresh
                  actions: actionsUI(context, fetchData),
                  columns: headersToColumns(_headers, onSort),
                  source:
                      _DataSource(context, _rows[_currentPage]!, _selectedRow,
                          onChanged: (index, valueColumn, value) {
                    _rows[_currentPage]![index][valueColumn] = value;
                  },
                          onDelete: onDelete,
                          onSelect: onselect,
                          isSelected: _isSelected,
                          onEdit: onEditRow,
                          onSaved: onSavedRow),
                )),
          );
  }

  Future<void> onSavedRow(int index) async {
    try {
      final row = _rows[_currentPage]![index];
      await _httpServices
          .updateRow(widget.sheetTitle, row, index)
          .then((value) {
        AppMethods.showMessage(context, 'Row updated successfully');
        setState(() => _selectedRow = -1);
      });
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
  }

  Future<void> onEditRow(int index) async =>
      setState(() => _selectedRow = index);

  void onSelectAll(bool? checked) {
    setState(() {
      _isAllSelected.value = checked!;
      _isSelected.clear();
      _rows[_currentPage]!.forEach((_) => _isSelected.add(checked));
    });
  }

  void onselect(int index) {
    Log.debug('Selected index: $index');
    setState(() {
      if (!_isSelected[index]) {
        _isAllSelected.value = false;
      } else if (_isSelected.every((element) => element)) {
        _isAllSelected.value = true;
      }
      _isSelected[index] = !_isSelected[index];
    });
  }

  List<Widget> actionsUI(BuildContext context, Function fetchData) => [
        IconButton(
            icon: const Icon(Icons.refresh, color: BLUE_COLOR),
            onPressed: () async {
              _rows.clear();
              _headers.clear();
              _currentPage = 1;
              await fetchData(isFetchingHeaders: true);
            }),
        IconButton(
          icon: const Icon(Icons.add, color: BLUE_COLOR),
          onPressed: onAdd,
        ),
      ];

  void onAdd() {
    AppMethods.showErrorMessage(context, 'Feature not yet implemented');
  }

  Future<void> onDelete(int index) async {
    try {
      await AppMethods.showConfirmDialog(context, DELETE_ROW_CONFIRM_MESSAGE,
          () async {
        await _httpServices
            .deleteRow(widget.sheetTitle, index + 1)
            .then((value) {
          AppMethods.showMessage(context, 'Row deleted successfully');
          setState(() {
            _rows[_currentPage]!.removeAt(index);
            _isSelected.removeAt(index);
          });
          fetchData();
        }).onError((error, stackTrace) {
          AppMethods.showErrorMessage(context, error.toString());
        });
      });
    } catch (e) {
      AppMethods.showErrorMessage(context, e.toString());
    }
  }

  void editRow() {
    AppMethods.showErrorMessage(context, 'Feature not yet implemented');
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
        .toList()
      ..add(const DataColumn(label: Text('Actions')));
  }

  void onPageChanged(int index) async {
    setState(() {
      _currentPage = index + 1;
    });
    await fetchData();
  }

  void setRowsPerPage(int? value) {
    setState(() => _rowsPerPage = value!);
    _rows.clear();
    fetchData();
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, this.data, this.selectedRow,
      {required this.onSelect,
      required this.onChanged,
      required this.isSelected,
      required this.onEdit,
      required this.onDelete,
      required this.onSaved});

  final BuildContext context;
  final List<List<dynamic>> data;
  final Function(int) onSelect;
  final List<bool> isSelected;
  final Function(int) onEdit;
  final Function(int) onSaved;
  final Function(int, int, String) onChanged;
  final Function(int) onDelete;

  final int selectedRow;
  List<dynamic> row = [];

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    return DataRow.byIndex(
      index: index,
      color: getRowColor(index),
      selected: isSelected[index],
      onSelectChanged: (selected) {
        if (selected != null) {
          onSelect(index);
        }
      },
      cells: data[index]
          .map((cell) => DataCell(selectedRow == index
              ? TextFormField(
                  initialValue: cell.toString(),
                  onChanged: (value) {
                    onChanged(index, data[index].indexOf(cell), value);
                    notifyListeners();
                  })
              : Text(cell.toString())))
          .toList()
        ..add(DataCell(Row(children: [
          selectedRow == index
              ? IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    onSaved(index);
                    notifyListeners();
                  })
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onEdit(index);
                    notifyListeners();
                  }),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                onDelete(index);
                notifyListeners();
              }),
        ]))),
    );

    // return DataRow.byIndex(
    //     index: index,
    //     color: getRowColor(index),
    //     selected: isSelected[index],
    //     onSelectChanged: (selected) {
    //       if (selected != null) {
    //         onSelect(index);
    //       }
    //     },
    //     cells: data[index]
    //         .map((cell) => DataCell(Text(TConverter.valueToString(cell))))
    //         .toList()
    //       ..add(DataCell(IconButton(
    //           icon: const Icon(Icons.edit),
    //           onPressed: () {
    //             selectedRow = index;
    // onEdit(index);
    //           }))));
  }

  MaterialStateProperty<Color?> getRowColor(int index) =>
      MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Theme.of(context).colorScheme.primary.withOpacity(0.08);
        }
        if (index.isEven) {
          return Colors.grey.withOpacity(0.17);
        }
        return null;
      });

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
