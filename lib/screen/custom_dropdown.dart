import 'package:flutter/material.dart';

import '../UI/text_style.dart';

class CustomDropdownField<T> extends StatelessWidget {
    final String label;
    final String hintText;
    final T? value;
    final Color? fillColor;
    final BorderSide? borderSide;
    final bool? isMandatory;
    final List<T> items;
    final ValueChanged<T?>? onChanged;

    const CustomDropdownField({
        Key? key,
        required this.label,
        required this.hintText,
        this.value,
        this.fillColor,
        this.borderSide,
        this.isMandatory,
        required this.items,
        this.onChanged,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    children: [
                        Text(
                            label,
                            style: TextStyles.text,
                        ),
                        if (isMandatory == true)
                            Text(
                                "  ",
                                style: TextStyle(
                                    color: const Color(0xff7AB2D3),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                ),
                            ),
                    ],
                ),
                SizedBox(height: 5),
                DropdownButtonFormField<T>(
                    value: value,
                    hint: Text(
                        hintText,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                    ),
                    items: items.map((item) {
                        return DropdownMenuItem<T>(
                            value: item,
                            child: Text(
                                item.toString(),
                                style: TextStyle(fontSize: 16),
                            ),
                        );
                    }).toList(),
                    onChanged: onChanged,
                    isExpanded: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: fillColor ?? const Color(0xFFF9FAFB),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: borderSide ?? BorderSide.none,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: borderSide ?? BorderSide.none,
                        ),
                    ),
                ),
            ],
        );
    }
}