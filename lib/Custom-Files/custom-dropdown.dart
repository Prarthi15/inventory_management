import 'dart:js';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_management/Api/auth_provider.dart';

class CustomDropdown extends StatefulWidget {
  final double fontSize;
  int selectedIndex;
  final List<Map<String,dynamic>>option;
  final String? Function(String?)? validator;
  final bool isboxSize;
  final bool label;
  ValueChanged<int>? onSelectedChanged;

   CustomDropdown({super.key, this.validator, this.fontSize = 17,this.option=const [],this.isboxSize=false,this.label=false,this.selectedIndex=0,this.onSelectedChanged,});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem = 'Select option';
   List<String> _items = [
   'Select option'
   
  ];

  void updateData(){
    if(widget.label){
     for(int i=0;i<widget.option.length;i++){
        _items.add(widget.option[i]['labelSku']);
     }
     
    }else if(widget.isboxSize){
       for(int i=0;i<widget.option.length;i++){
        _items.add('${widget.option[i]['box_name']}');
     }
    }else{
        for(int i=0;i<widget.option.length;i++){
        _items.add('${widget.option[i]['name']}');
     }
    }
    setState(() {
       
     });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
  
    return DropdownButtonHideUnderline(
      child: Container(
        alignment: Alignment.topCenter,
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // errorStyle:'',
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue.shade100,
        ),
        child: DropdownSearch<String>(
          items: _items,
          selectedItem: _selectedItem,
          popupProps:const  PopupProps.menu(
            fit: FlexFit.tight,
            showSelectedItems: true,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              // cursorHeight:3,
              decoration: InputDecoration(
                hintText: "Search for an option",
                prefixIcon: Icon(Icons.search,size:20,),
                border: OutlineInputBorder(),
                constraints:BoxConstraints(maxHeight:30),
                isDense:true,
                filled:true,
                label:Text('Search'),
                contentPadding:EdgeInsets.all(0),
                
              ),
              
            ),
        //  itemBuilder: (context, item, isSelected)=>ListTile(
        //       title: Text(item),
        //       selected: isSelected,
        //     ),
            scrollbarProps:ScrollbarProps(
              // scrollbarOrientation:ScrollEndNotification
              // notificationPredicate:(b){
              //   print("b is ssssss $b");
              //   return true;
              // }
            ),
          ),
          onChanged: (String? newValue) {
              // _items.fin;
             widget.selectedIndex= _items.indexWhere((element) => element == newValue);
             if(widget.onSelectedChanged!=null){
              widget.onSelectedChanged!( widget.selectedIndex );
             }
             
            setState(() {
              _selectedItem = newValue;
              
            });
          },
        ),
      ),
    );
  }
}


class SimpleDropDown extends StatefulWidget {
  const SimpleDropDown({super.key});

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState();
}

class _SimpleDropDownState extends State<SimpleDropDown> {
  // DropdownMenuItem<String> vale='Hwlo';
  List<String> ans=['option 0','option 1'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:40,
      width:double.infinity,
      child:DropdownButton(
        value:'option 0',
        items:ans.map((e) =>DropdownMenuItem(child:Text(e))).toList(),
        onChanged:(val){},
        ),
    );
  }
}


class DropDownWithRow extends StatefulWidget {
  const DropDownWithRow({super.key});

  @override
  State<DropDownWithRow> createState() => _DropDownWithRowState();
}

class _DropDownWithRowState extends State<DropDownWithRow> {
  // DropdownMenuItem<String> vale='Hwlo';
  List<String> ans=['option 0','option 1'];
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:40,
      width:double.infinity,
      child:DropdownButton(
        value:'option 0',
        items:ans.map((e) =>DropdownMenuItem(child:Text(e))).toList(),
        onChanged:(val){},
        ),
    );
  }
}
