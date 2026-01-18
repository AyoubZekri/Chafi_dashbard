import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/NatureoftheactivityController.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/LabeledTextField.dart';
import '../Widget/TextFild/SearchFild.dart';

class Natureoftheactivity extends StatefulWidget {
  const Natureoftheactivity({super.key});

  @override
  State<Natureoftheactivity> createState() => _NatureoftheactivityState();
}

class _NatureoftheactivityState extends State<Natureoftheactivity> {
  @override
  Widget build(BuildContext context) {
    Get.create(() => Natureoftheactivitycontroller());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<Natureoftheactivitycontroller>(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'add_new'.tr,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  CustemtextfromfildInfoUser(
                                    myController: controller.namear,
                                    label: "name_ar".tr,
                                    hintText: 'enter_name_here'.tr,
                                  ),

                                  const SizedBox(height: 15),
                                  CustemtextfromfildInfoUser(
                                    myController: controller.namefr,
                                    label: "name_fr".tr,
                                    hintText: 'enter_name_here'.tr,
                                  ),
                                  const SizedBox(height: 30),
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
                                          'save'.tr,
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
      DataColumn(label: Text('name'.tr)),
      DataColumn(label: Text('created_at'.tr)),
      DataColumn(label: Text('actions'.tr)),
    ];
  }

  DataRow buildDataRow(Map<String, String> item) {
    return DataRow(
      cells: [
        DataCell(Text(item['id']!)),
        DataCell(Text(item['name']!)),
        DataCell(Text(item['created_at']!)),
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
