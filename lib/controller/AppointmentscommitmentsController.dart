import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentscommitmentscontrollerImp extends GetxController {
  // داخلAppointmentscommitmentscontrollerImp
  late TextEditingController typeAr;
  late TextEditingController typeFr;
  late TextEditingController deadline;
  late TextEditingController consequencesAr;
  late TextEditingController consequencesFr;
  late TextEditingController noticeDate;
  int? selectedsestemTax;
  final List<Map<String, String>> _allData = [
    {
      "id": "1",
      "type": "تصريح سنوي",
      "deadline": "2026-03-01",
      "consequences": "غرامة مالية قدرها 10%",
      "notice_date": "2025-12-11",
    },
    {
      "id": "2",
      "type": "تصريح فصلي",
      "deadline": "2026-06-15",
      "consequences": "تجميد مؤقت للحساب",
      "notice_date": "2025-08-16",
    },
    {
      "id": "3",
      "type": "ضريبة القيمة المضافة",
      "deadline": "2026-01-20",
      "consequences": "زيادة تأخير 5%",
      "notice_date": "2025-12-30",
    },
    {
      "id": "4",
      "type": "تقرير العمالة",
      "deadline": "2026-02-10",
      "consequences": "تنبيه إداري",
      "notice_date": "2026-01-05",
    },
    {
      "id": "5",
      "type": "تجديد الرخصة",
      "deadline": "2026-05-22",
      "consequences": "إيقاف النشاط مؤقتاً",
      "notice_date": "2025-11-20",
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
          (item) =>
              item['name']!.toLowerCase().contains(query.toLowerCase()) ||
              item['email']!.toLowerCase().contains(query.toLowerCase()),
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
