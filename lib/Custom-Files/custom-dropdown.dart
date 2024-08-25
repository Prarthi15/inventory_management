import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final double fontSize;
  final String? Function(String?)? validator;
  const CustomDropdown({super.key, this.validator,  this.fontSize=17});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  
  String? _selectedItem='Option 1';
  final List<String> _items = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];

  // _CustomDropdownState({ this.fontSize=17});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
          child: Container(
            alignment:Alignment.topCenter,
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              // errorStyle:'',
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.shade100,
              
            ),
            child: DropdownButton<String>(
              //  hint:
              dropdownColor:Colors.blue.shade100,
              hint: const Text('Select an option'),
              value: _selectedItem,
              isExpanded: true,
            
              icon: const Icon(Icons.arrow_drop_down),
              items: _items.map((String item) {
                
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Text(item,style:TextStyle(fontSize:widget.fontSize),),
                  ),
                );
              }).toList(),
              
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                  
                });
                
              },
            ),
          ),
        );
     
  }
}