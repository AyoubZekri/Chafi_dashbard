import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Natureoftheactivitycontroller extends GetxController {
  late TextEditingController namear;
  late TextEditingController namefr;


  final List<Map<String, String>> _allData = [
    {
      "id": "1",
      "name": "Google",
      "created_at": "2026-01-05",
    },
    {
      "id": "2",
      "name": "YouTube",
      "created_at": "2026-01-05",
    },
    {
      "id": "3",
      "name": "GitHub",
      "created_at": "2026-01-05",
    },
    {
      "id": "4",
      "name": "Stack Overflow",
      "created_at": "2026-01-05",
    },
    {
      "id": "5",
      "name": "Flutter",
      "created_at": "2026-01-05",
    },
  ];

  List<Map<String, String>> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

 

  @override
  void onInit() {
    namear = TextEditingController();
    namefr = TextEditingController();

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
