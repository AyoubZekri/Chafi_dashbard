import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/Colorapp.dart';

/// نفس تصميم [Dropdownfild] مع حقل بحث داخل القائمة
class SearchableDropdownfild<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String label;
  final String hintText;
  final String searchHint;

  /// النص الذي يُبحث فيه لكل عنصر
  final String Function(T value) searchText;
  final void Function(T?) onChanged;

  const SearchableDropdownfild({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.hintText,
    required this.searchText,
    this.searchHint = 'بحث...',
  });

  @override
  State<SearchableDropdownfild<T>> createState() =>
      _SearchableDropdownfildState<T>();
}

class _SearchableDropdownfildState<T> extends State<SearchableDropdownfild<T>> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool _matches(DropdownMenuItem<T> item, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty || item.value == null) return true;
    final text = widget.searchText(item.value as T).toLowerCase();
    // كل كلمة من البحث يجب أن تظهر في النص (مثال: "12 مكرر")
    return q.split(RegExp(r'\s+')).every(text.contains);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColor.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border.all(width: 1, color: AppColor.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              isExpanded: true,
              hint: Text(
                widget.hintText,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.grey,
                ),
              ),
              items: widget.items,
              value: widget.value,
              onChanged: widget.onChanged,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 360,
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
              dropdownSearchData: DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 56,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: TextField(
                    controller: searchController,
                    autofocus: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: widget.searchHint,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, query) => _matches(item, query),
              ),
              // تفريغ البحث عند إغلاق القائمة
              onMenuStateChange: (isOpen) {
                if (!isOpen) searchController.clear();
              },
            ),
          ),
        ),
      ],
    );
  }
}
