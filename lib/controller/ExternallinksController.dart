import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternallinkscontrollerImp extends GetxController {
  late TextEditingController namear;
  late TextEditingController namefr;
  late TextEditingController link;

  int? selectedsestemTax;
  final List<Map<String, String>> _allData = [
    {
      "id": "1",
      "name": "Google",
      "link": "https://www.google.com",
      "created_at": "2026-01-05",
    },
    {
      "id": "2",
      "name": "YouTube",
      "link": "https://www.youtube.com",
      "created_at": "2026-01-05",
    },
    {
      "id": "3",
      "name": "GitHub",
      "link": "https://github.com",
      "created_at": "2026-01-05",
    },
    {
      "id": "4",
      "name": "Stack Overflow",
      "link": "https://stackoverflow.com",
      "created_at": "2026-01-05",
    },
    {
      "id": "5",
      "name": "Flutter",
      "link": "https://flutter.dev",
      "created_at": "2026-01-05",
    },
  ];

  List<Map<String, String>> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  final List<Map<String, Object>> sestemTax = [
    {'key': 0, 'label': "tax_flat_system".tr},
    {'key': 1, 'label': "tax_simplified_system".tr},
    {'key': 2, 'label': "tax_real_system".tr},
  ];

  @override
  void onInit() {
    namear = TextEditingController();
    namefr = TextEditingController();
    link = TextEditingController();

    filteredData = _allData;
    super.onInit();
  }

  List<Map<String, String>> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = _allData
        .where(
          (item) => item['name']!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    update();
  }

  void changePage(int index) {
    currentPage = index;
    update();
  }

  void changeRowsPerPage(int count) {
    rowsPerPage = count;
    currentPage = 0;
    update();
  }

  // دالة الصفحة التالية
  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      update();
    }
  }
}
