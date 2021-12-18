import 'package:flutter/material.dart';

class LocationsDataSource extends DataTableSource {
  var _locations = [];

  LocationsDataSource(var locations) {
    this._locations = locations;
  }

  int _selectedCount = 0;
  @override
  DataRow? getRow(int index) {
    final location = _locations[index];

    return DataRow.byIndex(
        index: index,
        onSelectChanged: (value) {
          // print(object);
        },
        cells: [DataCell(Text(location['name']))]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _locations.length;

  @override
  int get selectedRowCount => _selectedCount;
}
