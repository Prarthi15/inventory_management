import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final String title;
  final List<String> items;
  final String searchQuery;

  const FilterSection({
    super.key,
    required this.title,
    required this.items,
    required this.searchQuery,
  });

  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filterItems(widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant FilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterItems(widget.searchQuery);
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _filteredItems
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(item),
                    ))
                .toList(),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
