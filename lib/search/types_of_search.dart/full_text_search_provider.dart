import 'package:flutter/material.dart';

class FullTextSearchProvider with ChangeNotifier {
  static const String totalTextFields = 'totalTextFields';
  static const String textFields = 'textFields';
  Map<String, dynamic> _value = {
    textFields: [
      ['Any', 'AND'],
      ['Any', 'AND']
    ],
    totalTextFields: 2,
  };
  Map<String, dynamic> get value => _value;

  addToTextFields() {
    _value.update(textFields, (value) {
      value.add(['Any', 'AND']);
      return value;
    });
    _value.update(totalTextFields, (value) {
      return value + 1;
    });
    notifyListeners();
  }

  subtractFromTextFields(int index) {
    _value.update(textFields, (value) {
      value.removeAt(index);
      return value;
    });
    _value.update(totalTextFields, (value) {
      return value - 1;
    });
    notifyListeners();
  }

  updateHint(int index, String data) {
    _value.update(textFields, (value) {
      value[index].insert(0, data);
      return value;
    });
    notifyListeners();
  }

  updateANDOR(int index, String decision) {
    _value.update(textFields, (value) {
      value[index].insert(1, decision);
      return value;
    });
    if (index == 1)
      _value.update(textFields, (value) {
        value[index].insert(1, decision);
        return value;
      });
    notifyListeners();
  }
}
