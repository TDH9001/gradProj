import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../screen/theme/dark_theme_colors.dart';

class DropdownSelect extends StatefulWidget {
  DropdownSelect({
    super.key,
    required this.data,
    required this.cont,
    this.maxSelections = 8,
    this.isSearchable = true,
  });
  final List<DropdownItem<String>> data;
  final MultiSelectController<String> cont;
  final int maxSelections;
  final bool isSearchable;
  @override
  State<DropdownSelect> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DropdownSelect> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return MultiDropdown<String>(

        items: widget.data,
        maxSelections: widget.maxSelections,
        enabled: true,
        controller: widget.cont,
        searchEnabled: widget.isSearchable,
        chipDecoration: const ChipDecoration(
          backgroundColor: Colors.white60,
          wrap: true,
          runSpacing: 2,
          spacing: 10,
        ),
        fieldDecoration: FieldDecoration(
          hintText: 'DropdownSelect.days'.tr(),
          hintStyle:  TextStyle(color:isDarkMode ? Colors.white : Colors.black87),
          prefixIcon: const Icon(Icons.add_circle_rounded, color: Colors.grey),
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
        dropdownDecoration: DropdownDecoration(
          backgroundColor: isDarkMode ? DarkThemeColors.primary : Colors.white,
          marginTop: 2,
          maxHeight: 500,
          header:  Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'DropdownSelect.select_your_days'.tr(),
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
            return 'DropdownSelect.error'.tr();
          }
          return null;
        },
        onSelectionChange: (selectedValues) {
          if (selectedValues.length >= widget.maxSelections) {
            widget.cont.closeDropdown();
          } // Collapse the dropdown
        });
  }
}
