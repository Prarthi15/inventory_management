import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? Function(String?)? validator;
  const CustomDropdown({super.key, this.validator});

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

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              // errorStyle:'',
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.shade50,
              
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
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item),
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