import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoiningcategoriescontrollerImp extends GetxController {
  late TextEditingController typeAr;
  late TextEditingController typeFr;
  late TextEditingController deadline;
  late TextEditingController consequencesAr;
  late TextEditingController consequencesFr;
  late TextEditingController noticeDate;
  int? selectedsestemTax;
  final List<Map<String, String>> _allData = [
    {"id": "1", "category_name": "تاجر بالتجزئة", "tax_system": "نظام جزافي"},
    {
      "id": "2",
      "category_name": "مقاول أشغال عمومية",
      "tax_system": "نظام حقيقي",
    },
    {"id": "3", "category_name": "مكتب خدمات", "tax_system": "نظام مبسط"},
    {"id": "4", "category_name": "حرفي مستقل", "tax_system": "نظام جزافي"},
    {
      "id": "5",
      "category_name": "شركة ذات مسؤولية محدودة",
      "tax_system": "نظام حقيقي",
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
    typeAr = TextEditingController();
    typeFr = TextEditingController();
    deadline = TextEditingController();
    consequencesAr = TextEditingController();
    consequencesFr = TextEditingController();
    noticeDate = TextEditingController();
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
