import 'package:flutter/material.dart';

class FullTextSearchProvider with ChangeNotifier {
  static const String totalTextFields = 'totalTextFields',
      textFields = 'textFields';
  Map<String, dynamic> _value = {
    textFields: [
      {'fieldCode': "any", 'fieldValue': ""},
    ],
    totalTextFields: 1,
  };
  List _filters = [],
      _locations = [],
      _limitersList = [],
      _currentLocations = [],
      _selectedCampus = [];
  List get locations => _locations;
  List get filters => _filters;
  List get currentLocations => _currentLocations;
  List get limiterList => _limitersList;
  String? _sortBy = 'relevance', _sortType = 'asc';

  Map<String, dynamic> get value => _value;

  String? get sortBy => _sortBy;
  String? get sortType => _sortType;
  List get selectedCampus => _selectedCampus;

  setLocations(var location, bool isSingle, [int? length]) {
    if (isSingle) {
      if (_locations
          .where((element) => element['code'] == location['code'])
          .isEmpty) {
        _locations.add(location);
      } else {
        _locations
            .removeWhere((element) => element['code'] == location['code']);
      }
    } else {
      if (_locations.isEmpty || _locations.length != length) {
        _locations = location;
      } else if (_locations.length == length) {
        _locations = [];
      }
    }
    notifyListeners();
  }

  setFilter(var data) {
    Map<String, dynamic> filterParamters = {
      'fieldName': "docTypeFacet",
      'values': [data['code']]
    };
    bool parameterAlreadyExists = _filters
        .where((element) => element['fieldName'] == 'docTypeFacet')
        .isNotEmpty;
    if (parameterAlreadyExists)
      _filters.removeWhere((element) => element['fieldName'] == 'docTypeFacet');
    _filters.add(filterParamters);
    notifyListeners();
  }

  setLanguage(var data) {
    Map<String, dynamic> filterParamters = {
      'fieldName': "langFacet",
      'values': [data['code']]
    };
    bool parameterAlreadyExists = _filters
        .where((element) => element['fieldName'] == 'langFacet')
        .isNotEmpty;
    if (parameterAlreadyExists)
      _filters.removeWhere((element) => element['fieldName'] == 'langFacet');
    _filters.add(filterParamters);
    notifyListeners();
  }

  setSortBys(var data) {
    _sortBy = data['code'];
    notifyListeners();
  }

  setSortType(var data) {
    _sortType = data['code'];
    notifyListeners();
  }

  setYear(double start, double end) {
    _limitersList = ["DT:${start.round()}/${end.round()}"];
    notifyListeners();
  }

  addToTextFields(var initial, int index) {
    _value.update(textFields, (value) {
      Map<String, String> fields = {
        'fieldCode': initial['code'],
        'fieldValue': '',
        'fieldConj': 'AND'
      };
      value.add(fields);
      return value;
    });
    if (index == 0) {
      _value.update(textFields, (value) {
        value[0]['fieldConj'] = 'AND';
        return value;
      });
    }
    _value.update(totalTextFields, (value) {
      return value + 1;
    });
    notifyListeners();
  }

  setCampus(var data, var deptLocationList) {
    print(data);
    if (!_selectedCampus.contains(data['name'])) {
      _selectedCampus.add(data['name']);
      _currentLocations.addAll(deptLocationList[data['code']]);
      _currentLocations = _currentLocations.toSet().toList();
    } else {
      _selectedCampus.remove(data['name']);
      _currentLocations.toSet().removeAll(deptLocationList[data['code']]);
    }
    notifyListeners();
  }

  subtractFromTextFields(int index) {
    _value.update(textFields, (value) {
      value.removeAt(index);
      return value;
    });

    if (index == 1)
      _value.update(textFields, (value) {
        value[0].remove('fieldConj');
        return value;
      });
    _value.update(totalTextFields, (value) {
      return value - 1;
    });
    notifyListeners();
  }

  updateHint(int index, var data) {
    _value.update(textFields, (value) {
      value[index].update('fieldCode', (String fieldCode) {
        fieldCode = data['code'];
        return fieldCode;
      });
      return value;
    });
    notifyListeners();
  }

  updateFieldValue(int index, String text) {
    _value.update(textFields, (value) {
      value[index].update('fieldValue', (String fieldValue) {
        fieldValue = text;
        return fieldValue;
      });
      return value;
    });
    notifyListeners();
  }

  updateANDOR(int index, String decision) {
    _value.update(textFields, (value) {
      if (index == 1) {
        value[0].update('fieldConj', (String value) {
          value = decision;
          return value;
        });
      }
      value[index].update('fieldConj', (String value) {
        value = decision;
        return value;
      });
      return value;
    });

    notifyListeners();
  }

  clearAll() {
    _value = {
      textFields: [
        {'fieldCode': "any", 'fieldValue': ""},
      ],
      totalTextFields: 1,
    };
    _filters = [];
    _locations = [];
    _limitersList = [];
    _currentLocations = [];
    _selectedCampus = [];
    _sortBy = 'relevance';
    _sortType = 'asc';
    notifyListeners();
  }

  static String getName(List list, var data) {
    return list
        .where((element) => element['code'] == data['fieldCode'])
        .first['name'];
  }
}
