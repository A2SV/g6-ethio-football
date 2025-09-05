import 'package:ethio_football/core/Presentation/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required TextEditingController searchController,
    required this.hintText,
    required this.onChanged,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final String hintText;
  final ValueChanged<String> onChanged; // callback for flexibility

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontSize: kSearchBarText(
              context,
            ), // 👈 this controls the input text size
            color: Colors.black, // optional, set text color
          ),
          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: kSearchBarText(context),
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
            fillColor: Colors.grey.shade200,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged, // delegate search logic
        ),
      ),
    );
  }
}
