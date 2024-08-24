import 'package:flutter/material.dart';

class CheckBoxProvider with ChangeNotifier{
  List<bool> _listCheckBox = List.generate(5, (index) => false);
  bool _mainCheckBox = false;

  get mainCheckBox=>_mainCheckBox;
  List<bool> get checkboxStates=>_listCheckBox;

  void upDateMainCheckBox(bool val){
    // print("i am calling by dipu $val");
    _mainCheckBox=val;
     _listCheckBox = List.generate(5, (index) => val);
     notifyListeners();
  }
   void updateListCheckBox(bool val,int index){
    // _mainCheckBox=val;
    _listCheckBox[index]=val;
    notifyListeners();
  }
}