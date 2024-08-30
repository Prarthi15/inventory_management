// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class CheckBoxProvider with ChangeNotifier {
  List<bool> _listCheckBox = List.generate(5, (index) => false);
  List<bool> _listFailedCheckBox = List.generate(5, (index) => false);
  List<List<bool>> _subTextFieldEnabler1 =
      List.generate(5, (_) =>[]);
  List<List<bool>> _subTextFieldEnabler2 =
      List.generate(5, (_) =>[]);
  List<List<bool>> _failedOrderSubTextFieldEnabler1 =
      List.generate(5, (_) =>[false]);
  List<List<bool>> _failedOrderSubTextFieldEnabler2 =
      List.generate(5, (_) =>[false]);

  bool _mainCheckBox = false;
  bool failedOrderMainCheckBox = false;
  bool get mainCheckBox => _mainCheckBox;
  List<bool> get checkboxStates => _listCheckBox;
  List<bool> get failedcheckboxStates => _listFailedCheckBox;

  List<List<bool>> get getSubTextField1 => _subTextFieldEnabler1;
  List<List<bool>> get getSubTextField2 => _subTextFieldEnabler2;
  List<List<bool>> get getFailedSubTextField1 =>
      _failedOrderSubTextFieldEnabler1;
  List<List<bool>> get getFailedSubTextField2 =>
      _failedOrderSubTextFieldEnabler2;
 void generateConfirmSUbTextField(int rowNum,int colu) {
    for(int i=0;i<colu;i++){
      _subTextFieldEnabler1[rowNum].add(false);
      _subTextFieldEnabler2[rowNum].add(false);
    }

  }
  void generateFailedSUbTextField(int rowNum,int colu) {
    print("yse o oooooooooooooo");
    for(int i=0;i<colu;i++){
      print("yse o oooooooooooooo $rowNum  $i");
      _failedOrderSubTextFieldEnabler1[rowNum].add(false);
      _failedOrderSubTextFieldEnabler2[rowNum].add(false);
    }

  }
  void upDateMainCheckBox(bool val) {
    _mainCheckBox = val;
    _listCheckBox = List.generate(5, (index) => val);
    notifyListeners();
  }

  void upDateFailedMainCheckBox(bool val) {
    failedOrderMainCheckBox = val;
    _listFailedCheckBox = List.generate(5, (index) => val);
    notifyListeners();
  }

  void updateFailedOrderListCheckBox(bool val, int index) {
    _listFailedCheckBox[index] = val;
    notifyListeners();
  }

  void updateListCheckBox(bool val, int index) {
    _listCheckBox[index] = val;
    notifyListeners();
  }

  void updateSubTextFieldEnabler1(bool val, int index, int subIndex) {
    _subTextFieldEnabler1[index][subIndex] = val;
    notifyListeners();
  }

  void updateFailedSubTextFieldEnabler1(bool val, int index, int subIndex) {
    _failedOrderSubTextFieldEnabler1[index][subIndex] = val;
    notifyListeners();
  }

  void updateSubTextFieldEnabler2(bool val, int index, int subIndex) {
    _subTextFieldEnabler2[index][subIndex] = val;
    notifyListeners();
  }

  void updateFailedSubTextFieldEnabler2(bool val, int index, int subIndex) {
    _failedOrderSubTextFieldEnabler2[index][subIndex] = val;
    notifyListeners();
  }
}
