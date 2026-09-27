import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/TaxSearchController.dart';
import '../../core/constant/Colorapp.dart';
import '../../core/class/handlingview.dart';
import '../../data/model/TaxSearchModel.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TaxSearch/TaxActionIcon.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';
import '../Widget/TaxSearch/TaxSearchDialog.dart';
import '../../core/functions/Dealog.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxSearchFiles extends StatefulWidget {
  const TaxSearchFiles({super.key});

  @override
  State<TaxSearchFiles> createState() => _TaxSearchFilesState();
}

class _TaxSearchFilesState extends State<TaxSearchFiles> {
  final ScrollController horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Get.put(TaxSearchController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<TaxSearchController>(
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
                // Header Section: Title and Add Button
                Container(
                  alignment: Alignment.topLeft,
                  child: ActionButton(
                    label: 'add_new'.tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      controller.file = null;
                      controller.fileController.clear();
                      showDialog(
                        context: context,
                        builder: (context) => TaxSearchDialog(
                          mode: TaxSearchDialogMode.add,
                          controller: controller,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

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
                          PointerDeviceKind.mouse,
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
                              dataRowMinHeight: 60,
                              dataRowMaxHeight: double.infinity,
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
                                TaxSearchModel item = entry.value;

                                int realIndex =
                                    controller.currentPage *
                                        controller.rowsPerPage +
                                    index +
                                    1;

                                return DataRow(
                                  cells: [
                                    DataCell(Text(realIndex.toString())),
                                    DataCell(
                                      SizedBox(
                                        width: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            item.localizedTitle,
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                    ),

                                    DataCell(
                                      Text(
                                        item.updatedAt.toString().substring(
                                          0,
                                          10,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          TaxActionIcon(
                                            icon: Icons.delete,
                                            color: Colors.red,
                                            tooltip: 'حذف'.tr,
                                            onTap: () async {
                                              await showCustomConfirmationDialog(
                                                context,
                                                title: "تنبيه".tr,
                                                message: "هل أنت متأكد من الحذف؟".tr,
                                                onConfirmAction: () {
                                                  controller.deletData(item.id);
                                                },
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          TaxActionIcon(
                                            icon: Icons.edit,
                                            color: Colors.blue,
                                            tooltip: 'تعديل'.tr,
                                            onTap: () {
                                              controller.setEditData(item);
                                              showDialog(
                                                context: context,
                                                builder: (context) => TaxSearchDialog(
                                                  mode: TaxSearchDialogMode.edit,
                                                  controller: controller,
                                                  id: item.id,
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          TaxActionIcon(
                                            icon: Icons.info_outline,
                                            color: Colors.green,
                                            tooltip: 'التفاصيل'.tr,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text("التفاصيل".tr),
                                                  content: SingleChildScrollView(
                                                    child: Text(item.localizedBody),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text("إغلاق".tr),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
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
      DataColumn(label: Text("العنوان".tr)),
      DataColumn(label: Text('تاريخ'.tr)),
      DataColumn(label: Text('إجراءات'.tr)),
    ];
  }
}
