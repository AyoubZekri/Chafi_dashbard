import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:chafi_dashboard/data/model/NotificationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/NotificationController.dart';
import '../../core/class/handlingview.dart';
import '../../core/functions/Dealog.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/Notification/NotificationDealog.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';

class NotificationBar extends StatefulWidget {
  const NotificationBar({super.key});

  @override
  State<NotificationBar> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationBar> {
  final ScrollController horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Get.create(() => Notificationcontroller());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<Notificationcontroller>(
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
                Container(
                  alignment: Alignment.centerLeft,
                  child: ActionButton(
                    label: 'add_new'.tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Notificationdealog(
                          mode: NotificationdealogMode.add,
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
                    widget: Scrollbar(
                      controller: horizontalController,
                      thumbVisibility: true,
                      trackVisibility: true,
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
                                NotificationModel item = entry.value;

                                int realIndex =
                                    controller.currentPage *
                                        controller.rowsPerPage +
                                    index +
                                    1;

                                return DataRow(
                                  cells: [
                                    DataCell(Text((realIndex + 1).toString())),
                                    DataCell(Text(item.title)),
                                    DataCell(Text(item.localizedcontent)),
                                    DataCell(
                                      Text(
                                        controller.sestemTax
                                            .firstWhere(
                                              (e) => e['key'] == item.taxId,
                                              orElse: () => {'label': '-'},
                                            )['label']
                                            .toString(),
                                      ),
                                    ),

                                    DataCell(
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await showCustomConfirmationDialog(
                                                context,
                                                title: "تنبيه".tr,
                                                message:
                                                    "هل أنت متأكد من الحذف؟".tr,
                                                onConfirmAction: () {
                                                  controller.deletdata(item.id);
                                                },
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
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
                                                    Notificationdealog(
                                                      mode:
                                                          NotificationdealogMode
                                                              .edit,
                                                      controller: controller,
                                                      id: item.id,
                                                    ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
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

                                          const SizedBox(width: 10),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.amber.shade700,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                Icons.swap_vert,
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
      DataColumn(label: Text('العنوان'.tr)),
      DataColumn(label: Text('المحتوى'.tr)),
      DataColumn(label: Text('النضام الجبائي'.tr)),
      DataColumn(label: Text('actions'.tr)),
    ];
  }

}

// Pagination Footer
