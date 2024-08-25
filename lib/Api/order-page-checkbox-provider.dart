// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class CheckBoxProvider with ChangeNotifier {
  List<bool> _listCheckBox = List.generate(5, (index) => false);
  List<bool> _textFieldEnabler1 = List.generate(5, (index) => false);
  List<bool> _textFieldEnabler2 = List.generate(5, (index) => false);
  
  // Initialize with lists of length 1
  List<List<bool>> _subTextFieldEnabler1 = List.generate(5, (_) =>List.generate(10000,(_)=>false));
  List<List<bool>> _subTextFieldEnabler2 = List.generate(5, (_) =>List.generate(10000,(_)=>false));
  
  bool _mainCheckBox = false;
  bool get mainCheckBox => _mainCheckBox;
  List<bool> get checkboxStates => _listCheckBox;
  List<bool> get textFieldEnabler1 => _textFieldEnabler1;
  List<bool> get textFieldEnabler2 => _textFieldEnabler2;
  List<List<bool>> get getSubTextField1 => _subTextFieldEnabler1;
  List<List<bool>> get getSubTextField2 => _subTextFieldEnabler2;

  // void subTextFieldEnablerGenerator(int colu, int rowIndex) {
  //   if (rowIndex >= 0 && rowIndex < _subTextFieldEnabler1.length) {
  //     print('Before update:');
  //     print('Row $rowIndex length: ${_subTextFieldEnabler1[rowIndex].length}');
      
  //     // Extend the row if necessary
  //     while (_subTextFieldEnabler1[rowIndex].length < colu) {
  //       _subTextFieldEnabler1[rowIndex].add(false);
  //       _subTextFieldEnabler2[rowIndex].add(false);
  //     }
      
  //     // Trim the row if necessary
  //     if (_subTextFieldEnabler1[rowIndex].length > colu) {
  //       _subTextFieldEnabler1[rowIndex] = _subTextFieldEnabler1[rowIndex].sublist(0, colu);
  //       _subTextFieldEnabler2[rowIndex] = _subTextFieldEnabler2[rowIndex].sublist(0, colu);
  //     }
      
  //     print('After update:');
  //     print('Row $rowIndex length: ${_subTextFieldEnabler1[rowIndex].length}');
      
  //     // Debug output for previous row
  //     if (rowIndex > 0) {
  //       print('Length of previous row (rowIndex=${rowIndex - 1}): ${_subTextFieldEnabler1[rowIndex - 1].length}');
  //     }
  //     notifyListeners();
  //   } else {
  //     print('Invalid row index: $rowIndex');
  //   }
  // }

  void upDateMainCheckBox(bool val) {
    _mainCheckBox = val;
    _listCheckBox = List.generate(5, (index) => val);
    notifyListeners();
  }

  void updateListCheckBox(bool val, int index) {
    if (index >= 0 && index < _listCheckBox.length) {
      _listCheckBox[index] = val;
      notifyListeners();
    } else {
      print('Invalid index for checkbox: $index');
    }
  }

  void updatetextFieldEnabler1(bool val, int index) {
    if (index >= 0 && index < _textFieldEnabler1.length) {
      _textFieldEnabler1[index] = val;
      notifyListeners();
    } else {
      print('Invalid index for textFieldEnabler1: $index');
    }
  }

  void updateSubTextFieldEnabler1(bool val, int index, int subIndex) {
    if (index >= 0 && index < _subTextFieldEnabler1.length &&
        subIndex >= 0 && subIndex < _subTextFieldEnabler1[index].length) {
      _subTextFieldEnabler1[index][subIndex] = val;
      notifyListeners();
    } else {
      print('Invalid index for subTextFieldEnabler1: rowIndex=$index, subIndex=$subIndex');
    }
  }
   void updateSubTextFieldEnabler2(bool val, int index, int subIndex) {
    
      _subTextFieldEnabler2[index][subIndex] = val;
      notifyListeners();
    
  }

  void updatetextFieldEnabler2(bool val, int index) {
   
      _textFieldEnabler2[index] = val;
      notifyListeners();
   
  }
}