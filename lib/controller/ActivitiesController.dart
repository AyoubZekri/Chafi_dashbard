import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Activitiescontroller extends GetxController {
  late TextEditingController namear;
  late TextEditingController namefr;

  int? selectedsestemTax;
  int? selecttypeTheActivity;

  final List<Map<String, String>> Data = [
    {
      'id': '1',
      'name': 'مؤسسة النور',
      'name_of_the_Activity': 'التجارة العامة',
      'type_Sestyem': 'النظام الحقيقي',
      'created_at': '2026-01-05',
    },
    {
      'id': '2',
      'name': 'مؤسسة الفجر',
      'name_of_the_Activity': 'الخدمات',
      'type_Sestyem': 'النظام الجزافي',
      'created_at': '2026-01-06',
    },
    {
      'id': '3',
      'name': 'شركة الريادة',
      'name_of_the_Activity': 'الاستيراد والتصدير',
      'type_Sestyem': 'النظام الحقيقي',
      'created_at': '2026-01-07',
    },
    {
      'id': '4',
      'name': 'مؤسسة الأمان',
      'name_of_the_Activity': 'النقل',
      'type_Sestyem': 'النظام المبسط',
      'created_at': '2026-01-08',
    },
    {
      'id': '5',
      'name': 'شركة المستقبل',
      'name_of_the_Activity': 'الصناعة',
      'type_Sestyem': 'النظام الحقيقي',
      'created_at': '2026-01-09',
    },
  ];

  final List<Map<String, Object>> sestemTax = [
    {'key': 0, 'label': "tax_flat_system".tr},
    {'key': 1, 'label': "tax_simplified_system".tr},
    {'key': 2, 'label': "tax_real_system".tr},
  ];

  final List<Map<String, Object>> typeTheActivit = [
    {'key': 0, 'label': "تاجر".tr},
    {'key': 1, 'label': "حرفي".tr},
    {'key': 2, 'label': "فلاح".tr},
  ];

  List<Map<String, String>> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  @override
  void onInit() {
    namear = TextEditingController();
    namefr = TextEditingController();

    filteredData = Data;
    super.onInit();
  }

  List<Map<String, String>> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = Data
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
