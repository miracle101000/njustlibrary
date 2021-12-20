import 'package:flutter/material.dart';

class SearchResultProvider with ChangeNotifier {
  List _filters = [];

  bool _hasFilters = false;

  List get filters => _filters;
  bool get hasFilters => _hasFilters;

  updateFiltersList(String facetType, String value, [int? index]) {
    if (index == null) {
      if (_filters.isNotEmpty) {
        if (_filters
            .where((element) => element['fieldName'] == facetType)
            .isEmpty) {
          Map<String, dynamic> filter = {
            'fieldName': facetType,
            'values': [value]
          };
          _filters.add(filter);
        } else {
          _filters
              .where((element) => element['fieldName'] == facetType)
              .first
              .update('values', (list) {
            list.add(value);
            return list;
          });
        }
      } else {
        Map<String, dynamic> filter = {
          'fieldName': facetType,
          'values': [value]
        };
        _filters.add(filter);
      }
    } else {
      _filters
          .where((element) => element['fieldName'] == facetType)
          .first
          .update('values', (list) {
        list.removeWhere((element) => element == value);
        return list;
      });
    }
    notifyListeners();
  }

  clearThisFacet(String facetType) {
    _filters.removeWhere((element) => element['fieldName'] == facetType);
    notifyListeners();
  }

  setHasFilter(bool value) {
    _hasFilters = value;
    notifyListeners();
  }

  clearAll() {
    _filters = [];
    notifyListeners();
  }
}
