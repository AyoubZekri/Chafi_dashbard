import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notificationcontroller extends GetxController {
  late TextEditingController namear;
  late TextEditingController namefr;
  late TextEditingController link;

  bool isSistem = false;

  int? selectedsestemTax;
  final List<Map<String, String>> _allData = [
    {
      "id": "1",
      "title": "تصريح سنوي",
      "content": "آخر أجل لإيداع التصريح السنوي هو 01 مارس 2026.",
      "system": "نظام حقيقي",
    },
    {
      "id": "2",
      "title": "تصريح فصلي",
      "content": "بقي 15 يوم على موعد التصريح الفصلي.",
      "system": "نظام مبسط",
    },
    {
      "id": "3",
      "title": "ضريبة القيمة المضافة",
      "content": "تأخر في دفع TVA، سيتم تطبيق زيادة 5%.",
      "system": "نظام حقيقي",
    },
    {
      "id": "4",
      "title": "تقرير العمالة",
      "content": "يرجى إيداع تقرير العمالة قبل 10 فيفري.",
      "system": "نظام جزافي",
    },
    {
      "id": "5",
      "title": "تجديد الرخصة",
      "content": "انتهت صلاحية الرخصة، يرجى التجديد لتفادي إيقاف النشاط.",
      "system": "نظام مبسط",
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

  void toggleSystem(bool val) {
    isSistem = val;
    update(); 
  }

void setSystemTax(int? val) {
  selectedsestemTax = val;
  update();
}

  List<Map<String, String>> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = _allData
        .where(
          (item) =>
              item['title']!.toLowerCase().contains(query.toLowerCase()) ||
              item['content']!.toLowerCase().contains(query.toLowerCase()),
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
