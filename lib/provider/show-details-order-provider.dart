import 'package:flutter/material.dart';

class OrderItemProvider extends ChangeNotifier{
  List<List<bool>>?_orderItemCheckBox;

  List<List<bool>>? get orderItemCheckBox =>_orderItemCheckBox;
  void numberOfOrderCheckBox(int row,List<int>count){
    _orderItemCheckBox=List.generate(row, (index) =>List.generate(count[index], (ind)=>false));
    notifyListeners();
  }
    void updateCheckBoxValue(int row,int col){
    _orderItemCheckBox![row][col]=!_orderItemCheckBox![row][col];
    notifyListeners();
  }
}