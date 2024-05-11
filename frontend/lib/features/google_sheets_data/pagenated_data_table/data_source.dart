import 'package:flutter/material.dart';

class DataSource extends DataTableSource {
  DataSource(this.context, this.data, this.selectedRow,
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
              ? textFormField(index, data[index].indexOf(cell), cell.toString())
              : Text(cell.toString())))
          .toList()
        ..add(DataCell(Row(children: [
          editButton(index),
          deleteButton(index),
        ]))),
    );
  }

  Widget deleteButton(int index) => IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        onDelete(index);
        notifyListeners();
      });

  Widget editButton(int index) => selectedRow == index
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
          });

  Widget textFormField(int index, int valueColumn, String value) =>
      TextFormField(
          initialValue: value,
          onChanged: (value) {
            onChanged(index, valueColumn, value);
            notifyListeners();
          });

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