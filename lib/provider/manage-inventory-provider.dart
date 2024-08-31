import 'package:flutter/cupertino.dart';

class ManagementProvider extends ChangeNotifier{
  int _selectedPage=1;
  int _numberofPages=10;
  int _firstval=1;
  int _lastval=5;
  int _jump=5;
  get selectedPage=>_selectedPage;
  get numberofPages=>_numberofPages;
  get firstval=>_firstval;
  get lastval=>_lastval;
  get jump=>_jump;

  void upDateSelectedPage(int val){
    print("i am called upadet page $val");
    _selectedPage=val;
    _firstval = (val - 1) * _jump;
    _lastval = _firstval + _jump;
    notifyListeners();
  }
   void upDateJump(int val){
    _jump=val;
     
    notifyListeners();
  }
   void upNumberofPages(int val){
    _numberofPages=val;
    notifyListeners();
  }
   void upDateFirstAndLastVal(int firstVal,int lastVal){
   
    _firstval=firstVal;
    _lastval=lastVal;
    notifyListeners();
  }
 

}