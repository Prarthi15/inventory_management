import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final double fontSize;
  final String? Function(String?)? validator;
  const CustomDropdown({super.key, this.validator, this.fontSize = 17});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem = 'Option 1';
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
            setState(() {
              _selectedItem = newValue;
            });
          },
        ),
      ),
    );
  }
}
