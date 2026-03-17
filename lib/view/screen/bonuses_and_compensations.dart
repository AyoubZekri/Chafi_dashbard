import 'dart:ui';

import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/BonusesAndCompensationsController.dart';
import '../../core/class/handlingview.dart';
import '../../core/functions/Dealog.dart';
import '../../data/model/BonusModel.dart';
import '../../data/model/NatureoftheactivityModel.dart';
import '../Widget/Bonusesandcompensations/CstuembonusesandcompensationsDealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';

class BonusesAndCompensations extends StatefulWidget {
  const BonusesAndCompensations({super.key});

  @override
  State<BonusesAndCompensations> createState() =>
      _BonusesAndCompensationsState();
}

class _BonusesAndCompensationsState extends State<BonusesAndCompensations> {
  final ScrollController horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Get.create(() => Bonusesandcompensationscontroller());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<Bonusesandcompensationscontroller>(
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
                        builder: (context) =>
                            Cstuembonusesandcompensationsdealog(
                              mode: BonusesandcompensationsDialogMode.add,
                              controller: controller,
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
                                rows: controller.pagedData.asMap().entries.map((
                                  entry,
                                ) {
                                  int index = entry.key;
                                  BonusModel item = entry.value;

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
                                      DataCell(Text(item.localizedName)),
                                      DataCell(
                                        Text(
                                          controller.cat
                                              .firstWhere(
                                                (e) =>
                                                    e['key'] == item.category,
                                                orElse: () => {'label': '-'},
                                              )['label']
                                              .toString()
                                              .tr,
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await showCustomConfirmationDialog(
                                                  context,
                                                  title: "تنبيه",
                                                  message:
                                                      "هل أنت متأكد من الحذف؟",
                                                  onConfirmAction: () {
                                                    controller.deletdata(
                                                      item.id,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                controller.setEditData(item);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      Cstuembonusesandcompensationsdealog(
                                                        mode:
                                                            BonusesandcompensationsDialogMode
                                                                .edit,
                                                        controller: controller,
                                                        id: item.id,
                                                      ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
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
      DataColumn(label: Text('الفئة'.tr)),
      DataColumn(label: Text('actions'.tr)),
    ];
  }
}
