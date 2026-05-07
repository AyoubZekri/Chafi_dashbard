import 'dart:ui';

import 'package:chafi_dashboard/controller/UsersController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widget/Users/UserFeedbackDialog.dart';
import '../../core/class/handlingview.dart';

import '../../data/model/UsersModel.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final ScrollController horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Get.create(() => Userscontroller());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<Userscontroller>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 30),

                // شريط البحث و Rows per page
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 600;
                    return SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: isMobile
                            ? WrapAlignment.center
                            : WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 16,
                        spacing: 16,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'show'.tr,
                                style: const TextStyle(
                                  color: Color(0xFF5A6A85),
                                ),
                              ),
                              SizedBox(
                                width: 150,
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
                                style: const TextStyle(
                                  color: Color(0xFF5A6A85),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: isMobile ? constraints.maxWidth : 260,
                            child: SearchField(
                              onChanged: controller.filterData,
                              hint: "search".tr,
                              vertical: 5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            
                const SizedBox(height: 24),

                // الجدول
                Expanded(
                  child: Handlingview(
                    statusrequest: controller.statusrequest,
                    widget: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        scrollbars: true,
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse, // هنا نضيف دعم الفأرة
                        },
                      ),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          scrollbars: true,
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse, // هنا نضيف دعم الفأرة
                          },
                        ),
                        child: SingleChildScrollView(
                          controller: horizontalController,
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            child: SingleChildScrollView(
                              child: DataTable(
                                headingRowHeight: 50,
                                dataRowHeight: 50,
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
                                rows: controller.pagedData.asMap().entries.map((
                                  entry,
                                ) {
                                  int index = entry.key;
                                  UserModel item = entry.value;

                                  int realIndex =
                                      controller.currentPage *
                                          controller.rowsPerPage +
                                      index +
                                      1;

                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text((realIndex + 1).toString()),
                                      ),
                                      DataCell(Text(item.username)),

                                      DataCell(Text(item.numperPhone)),
                                      DataCell(Text(item.wilaya.tr)),

                                      DataCell(Text(item.email)),
                                      DataCell(
                                        Text(item.statsCount?.toString() ?? "0"),
                                      ),
                                      DataCell(
                                        InkWell(
                                          onTap: () {
                                            Get.dialog(
                                              UserFeedbackDialog(
                                                feedback: item.feedback ?? [],
                                                options: controller.options,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.blue),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "view_feedback".tr,
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                if ((item.feedback?.length ?? 0) > 0) ...[
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.blue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      item.feedback!.length.toString(),
                                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          item.createdAt.toString().substring(
                                            0,
                                            10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
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
      const DataColumn(label: Text("#")),
      DataColumn(label: Text("الإسم".tr)),
      DataColumn(label: Text('رقم الهاتف'.tr)),
      DataColumn(label: Text('الولاية'.tr)),
      DataColumn(label: Text('بريد الإلكتروني'.tr)),
      DataColumn(label: Text('total_access_count'.tr)),
      DataColumn(label: Text('user_opinion'.tr)),
      DataColumn(label: Text('created_at'.tr)),
    ];
  }
}

// Pagination Footer
