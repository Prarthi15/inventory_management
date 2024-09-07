import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/Api/auth_provider.dart';

class CustomDropdown extends StatefulWidget {
  final double fontSize;
   int selectedIndex;
  final List<Map<String,dynamic>>option;
  final String? Function(String?)? validator;
<<<<<<< HEAD
  final bool isboxSize;
  ValueChanged<int>? onSelectedChanged;

   CustomDropdown({super.key, this.validator, this.fontSize = 17,this.option=const [],this.isboxSize=false,this.selectedIndex=0,this.onSelectedChanged,});
=======
  const CustomDropdown({super.key, this.validator, this.fontSize = 17});
>>>>>>> 1cc37af87897cc47c26db6d7b5d7ca24fe2cba5f

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
<<<<<<< HEAD
  String? _selectedItem = 'Select option';
   List<String> _items = [
   'Select option'
   
=======
  String? _selectedItem = 'Option 1';
  final List<String> _items = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
>>>>>>> 1cc37af87897cc47c26db6d7b5d7ca24fe2cba5f
  ];

  // _CustomDropdownState({ this.fontSize=17});
  void updateData(){
    if(widget.option.isNotEmpty && widget.isboxSize==false){
    //  _selectedItem=widget.option[0]['name'];
    //  _items.clear();
     for(int i=0;i<widget.option.length;i++){
        _items.add(widget.option[i]['name']);
     }
     
    }else{
        for(int i=0;i<widget.option.length;i++){
        _items.add('length: ${widget.option[i]['length']}  width: ${widget.option[i]['width']} height: ${widget.option[i]['height']}');
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
          popupProps: const PopupProps.menu(
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
                contentPadding:EdgeInsets.all(0)
              ),
            ),
            // itemBuilder:
          ),
          onChanged: (String? newValue) {
<<<<<<< HEAD
              // _items.fin;
             widget.selectedIndex= _items.indexWhere((element) => element == newValue);
             if(widget.onSelectedChanged!=null){
              widget.onSelectedChanged!( widget.selectedIndex );
             }
             
            setState(() {
              _selectedItem = newValue;
              
              // widget.=0;
=======
            setState(() {
              _selectedItem = newValue;
>>>>>>> 1cc37af87897cc47c26db6d7b5d7ca24fe2cba5f
            });
          },
        ),
      ),
    );
  }
}
<<<<<<< HEAD


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
=======
>>>>>>> 1cc37af87897cc47c26db6d7b5d7ca24fe2cba5f
