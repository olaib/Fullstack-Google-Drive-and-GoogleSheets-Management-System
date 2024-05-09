import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final void Function(List<String> row) onRemove;
  const CustomDataTable({
    super.key,
    required this.onRemove,
    required this.headers,
    required this.rows,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DataTable(
          dividerThickness: 2,
          columns: headers.map((header) {
            return DataColumn(
              label: Text(
                header,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          rows: rows.map((row) {
            return DataRow(
              cells: row
                  .asMap()
                  .map((index, cell) {
                    return MapEntry(
                      index,
                      DataCell(
                        Text(
                          cell,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  })
                  .values
                  .toList()
                ..add(
                  DataCell(
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemove(row)),
                  ),
                ),
            );
          }).toList(),
        ),
      ],
    );
  }
}