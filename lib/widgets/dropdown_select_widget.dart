import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DropdownSelect extends StatefulWidget {
  DropdownSelect({super.key, required this.data, required this.cont});
  final List<DropdownItem<String>> data;
  final MultiSelectController<String> cont;
  @override
  State<DropdownSelect> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DropdownSelect> {
  @override
  Widget build(BuildContext context) {
    return MultiDropdown<String>(
      items: widget.data,
      maxSelections: 8,
      enabled: true, controller: widget.cont,
      searchEnabled: true,
      chipDecoration: const ChipDecoration(
        backgroundColor: Colors.white60,
        wrap: true,
        runSpacing: 2,
        spacing: 10,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'Courses',
        hintStyle: const TextStyle(color: Colors.black87),
        prefixIcon: const Icon(Icons.add_circle_rounded),
        showClearIcon: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.black87,
          ),
        ),
      ),
      dropdownDecoration: const DropdownDecoration(
        marginTop: 2,
        maxHeight: 500,
        header: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Select Your Courses',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Course';
        }
        return null;
      },
    );
  }
}
