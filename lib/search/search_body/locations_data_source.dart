import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_body_provider.dart';

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
        selected: false,
        onSelectChanged: (value) {
          // print(object);
        },
        cells: [
          DataCell(
            Consumer<SearchBodyProvider>(
                builder: (context, data, child) => GestureDetector(
                    child: Row(children: [
                      if (data.locations
                          .where(
                              (element) => element['code'] == location['code'])
                          .isNotEmpty)
                        Icon(
                          Icons.check_box,
                          color: Colors.purple,
                        ),
                      if (data.locations.isEmpty ||
                          data.locations
                              .where((element) =>
                                  element['code'] == location['code'])
                              .isEmpty)
                        Icon(
                          Icons.crop_square_outlined,
                          color: Colors.purple,
                        ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(location['name']),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                      )
                    ]),
                    onTap: () {
                      data.setLocations(location, true);
                    })),
          )
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _locations.length;

  @override
  int get selectedRowCount => _selectedCount;
}
