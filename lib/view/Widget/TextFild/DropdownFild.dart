import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/Colorapp.dart';

class Dropdownfild<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String label;
  final String hintText;

  final void Function(T?) onChanged;

  const Dropdownfild({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.label, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColor.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          // margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(width: 1, color: AppColor.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
               hint: Row(
                children: [
                  Expanded(
                    child: Text(
                      hintText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: items,
              value: value,
              onChanged: onChanged,
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(255, 203, 201, 201),
                  ),
                ),
                elevation: 8,
              ),

              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 24,
                iconEnabledColor: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
