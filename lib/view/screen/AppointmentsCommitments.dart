import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/AppointmentscommitmentsController.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TextFild/CustemDatePickerInfoUser.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/DropdownFild.dart';
import '../Widget/TextFild/LabeledTextField.dart';
import '../Widget/TextFild/SearchFild.dart';

class Appointmentscommitments extends StatefulWidget {
  const Appointmentscommitments({super.key});

  @override
  State<Appointmentscommitments> createState() =>
      _AppointmentscommitmentsState();
}

class _AppointmentscommitmentsState extends State<Appointmentscommitments> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => AppointmentscommitmentscontrollerImp());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<AppointmentscommitmentscontrollerImp>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(24.0),
            margin: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // زر إضافة
                Container(
                  alignment: Alignment.centerLeft,
                  child: ActionButton(
                    label: 'add_new'.tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 800,
                            padding: const EdgeInsets.all(24),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'add_new_commitment'.tr,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // الصف الأول: نوع التصريح
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          myController: controller.typeAr,
                                          label: 'type_ar'.tr,
                                          hintText: 'type_hint_ar'.tr,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          myController: controller.typeFr,
                                          label: 'type_fr'.tr,
                                          hintText: 'type_hint_fr'.tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  Dropdownfild(
                                    label: 'system_tax'.tr,
                                    hintText: 'system_tax_hint'.tr,
                                    items: controller.sestemTax
                                        .map(
                                          (f) => DropdownMenuItem<int>(
                                            value: f['key'] as int,
                                            child: Text(
                                              f['label'].toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    value: controller.selectedsestemTax,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.selectedsestemTax = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 15),

                                  CustemDatePickerInfoUser(
                                    label: 'deadline'.tr,
                                    hintText: 'deadline_hint'.tr,
                                    myController: controller.deadline,
                                    context: context,
                                  ),
                                  const SizedBox(height: 15),

                                  // الصف الثالث: التبعيات
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          myController:
                                              controller.consequencesAr,
                                          label: 'consequences_ar'.tr,
                                          hintText: 'ماذا يحدث عند التأخير؟',
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: CustemtextfromfildInfoUser(
                                          myController:
                                              controller.consequencesFr,
                                          label: 'consequences_fr'.tr,
                                          hintText: 'consequences_fr'.tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),

                                  CustemDatePickerInfoUser(
                                    label: 'notice_date'.tr,
                                    hintText: 'notice_date_hint'.tr,
                                    myController: controller.noticeDate,
                                    context: context,
                                  ),

                                  const SizedBox(height: 30),

                                  // أزرار التحكم
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text(
                                          'cancel'.tr,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF6269F2,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'add_commitment'.tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // شريط البحث و Rows per page
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'show'.tr,
                          style: const TextStyle(color: Color(0xFF5A6A85)),
                        ),
                        SizedBox(
                          width: 140,
                          child: CustemDropDownField(
                            items: [10, 25, 50, 100].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            value: controller.rowsPerPage,
                            onChanged: (value) {
                              setState(() {
                                controller.rowsPerPage = value!;
                                controller.currentPage = 0;
                              });
                            },
                          ),
                        ),
                        Text(
                          'entries'.tr,
                          style: const TextStyle(color: Color(0xFF5A6A85)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 260,
                      child: SearchField(
                        onChanged: controller.filterData,
                        hint: "search".tr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // الجدول
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowHeight: 50,
                          dataRowHeight: 60,
                          headingRowColor: MaterialStateProperty.all(
                            const Color(0xFFF8F9FA),
                          ),
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          columns: buildColumns(),
                          rows: controller.pagedData
                              .map((item) => buildDataRow(item))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                TablePaginationFooter(
                  currentPage: controller.currentPage,
                  rowsPerPage: controller.rowsPerPage,
                  totalEntries: controller.filteredData.length,
                  totalPages: controller.totalPages,
                  currentFilteredLength: controller.filteredData.length,
                  onNext: controller.nextPage,
                  onPrevious: controller.previousPage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DataColumn> buildColumns() {
    return [
      DataColumn(label: Text("#")),
      DataColumn(label: Text('declaration_type'.tr)),
      DataColumn(label: Text('deadline'.tr)),
      DataColumn(label: Text('consequences'.tr)),
      DataColumn(label: Text('notice_date'.tr)),
      DataColumn(label: Text('actions'.tr)),
    ];
  }

  DataRow buildDataRow(Map<String, String> item) {
    return DataRow(
      cells: [
        DataCell(Text(item['id']!)),
        DataCell(Text(item['type']!)),
        DataCell(Text(item['deadline']!)),
        DataCell(Text(item['consequences']!)),
        DataCell(Text(item['notice_date']!)),
        DataCell(
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Pagination Footer
