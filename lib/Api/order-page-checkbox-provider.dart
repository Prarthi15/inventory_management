import 'package:flutter/material.dart';

class CheckBoxProvider with ChangeNotifier{
  List<bool> _listCheckBox = List.generate(5, (index) => false);
  List<bool> _textFieldEnabler1 = List.generate(5, (index) => false);
  List<bool> _textFieldEnabler2 = List.generate(5, (index) => false);
  bool _mainCheckBox = false;

  get mainCheckBox=>_mainCheckBox;
  List<bool> get checkboxStates=>_listCheckBox;
  List<bool> get textFieldEnabler1=>_textFieldEnabler1;
  List<bool> get textFieldEnabler2=>_textFieldEnabler2;

  void upDateMainCheckBox(bool val){
    
    _mainCheckBox=val;
     _listCheckBox = List.generate(5, (index) => val);
     notifyListeners();
  }
   void updateListCheckBox(bool val,int index){
    
    _listCheckBox[index]=val;
    notifyListeners();
  }
   void updatetextFieldEnabler1(bool val,int index){
    
    _textFieldEnabler1[index]=val;
    notifyListeners();
  }
   void updatetextFieldEnabler2(bool val,int index){
    
    _textFieldEnabler2[index]=val;
    notifyListeners();
  }
}