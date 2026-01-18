import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Lawcontroller extends GetxController {
  late TextEditingController nameAr;
  late TextEditingController nameFr;
  late TextEditingController fileController;

  String? selectedFileName;

  int? selectedsestemTax;
  final List<Map<String, String>> _allData = [
    {"id": "1", "law_name": "قانون الضرائب المباشرة"},
    {"id": "2", "law_name": "قانون الصفقات العمومية"},
    {"id": "3", "law_name": "قانون الجباية المهنية"},
    {"id": "4", "law_name": "قانون النشاطات الحرفية"},
    {"id": "5", "law_name": "قانون الشركات التجارية"},
  ];

  List<Map<String, String>> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  @override
  void onInit() {
    nameAr = TextEditingController();
    nameFr = TextEditingController();
    fileController = TextEditingController();


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
