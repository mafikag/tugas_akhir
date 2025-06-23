import 'package:flutter/material.dart';

class SearchBarView extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final List items; // Replace with your list of items
  final ValueChanged<List> onSearchChanged;
  SearchBarView({
    super.key,
    required this.items,
    required this.onSearchChanged,
  });

  void runSearch(String query) {
    List results = [];

    if (query.isEmpty) {
      // If the query is empty, return all items
      results = items;
    } else {
      // Filter the items based on the query
      results =
          items.where((item) {
            return item.toString().toLowerCase().contains(query.toLowerCase());
          }).toList();
    }

    // Notify the parent widget about the search results
    onSearchChanged(results);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Color.fromARGB(141, 39, 39, 39)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromARGB(141, 39, 39, 39),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color.fromARGB(141, 39, 39, 39),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFF272727), width: 2),
          ),
        ),
        onChanged: (value) {
          runSearch(value);
        },
      ),
    );
  }
}
