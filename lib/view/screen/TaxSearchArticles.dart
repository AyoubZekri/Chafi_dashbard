import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/TaxArticlesController.dart';
import '../../core/constant/Colorapp.dart';
import '../../core/class/handlingview.dart';
import '../../data/model/TaxArticleModel.dart';
import '../Widget/Button/ActionButton.dart';
import '../Widget/TablePaginationFooter.dart';
import '../Widget/TaxSearch/TaxActionIcon.dart';
import '../Widget/TextFild/CustemDropDownField.dart';
import '../Widget/TextFild/SearchFild.dart';
import '../Widget/TaxSearch/TaxArticleDialog.dart';
import '../Widget/TaxSearch/TaxTableView.dart';
import '../../core/functions/Dealog.dart';

class TaxSearchArticles extends StatefulWidget {
  const TaxSearchArticles({super.key});

  @override
  State<TaxSearchArticles> createState() => _TaxSearchArticlesState();
}

class _TaxSearchArticlesState extends State<TaxSearchArticles> {
  final ScrollController horizontalController = ScrollController();


  String _pages(TaxArticleModel item) {
    if (item.pageStart == null) return '-';
    if (item.pageEnd == null || item.pageEnd == item.pageStart) {
      return item.pageStart.toString();
    }
    return '${item.pageStart} - ${item.pageEnd}';
  }

  void _showDetails(BuildContext context, TaxArticleModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.localizedLabel),
        content: SizedBox(
          width: 700,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.missingTranslation)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'لا توجد ترجمة إنجليزية لهذه المادة'.tr,
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                  ),
                SelectableText(
                  item.localizedText,
                  textDirection: item.textDirection,
                ),
                if (item.notes.isNotEmpty) ...[
                  const Divider(height: 32),
                  Text(
                    'الملاحظات'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...item.notes.map((n) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $n'),
                      )),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إغلاق".tr),
          ),
        ],
      ),
    );
  }

  void _showTables(BuildContext context, TaxArticleModel item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 1000,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${'جداول'.tr} ${item.localizedLabel}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < item.tables.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child:
                              TaxTableView(table: item.tables[i], index: i),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TaxArticlesController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: GetBuilder<TaxArticlesController>(
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
                // Header Section: Add Button
                Container(
                  alignment: Alignment.topLeft,
                  child: ActionButton(
                    label: 'add_new'.tr,
                    icon: CupertinoIcons.add,
                    backgroundColor: AppColor.typography,
                    onPressed: () {
                      controller.clearForm();
                      showDialog(
                        context: context,
                        builder: (context) => TaxArticleDialog(
                          mode: TaxArticleDialogMode.add,
                          controller: controller,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // كل الفلاتر والبحث جنب بعض في سطر واحد
                Row(
                  children: [
                    // عرض كافٍ ليظهر الرقم كاملاً في سطر واحد
                    SizedBox(
                      width: 130,
                      child: CustemDropDownField(
                        items: [10, 25, 50, 100].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              maxLines: 1,
                              softWrap: false,
                            ),
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
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: CustemDropDownField<int>(
                        // أسماء الملفات طويلة: سطران لكل ملف
                        itemHeight: 64,
                        // 0 = كل الملفات
                        items: [
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text('كل الملفات'.tr),
                          ),
                          ...controller.documents.map(
                            (doc) => DropdownMenuItem<int>(
                              value: doc.id,
                              child: Text(
                                doc.localizedTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        value: controller.selectedDocumentId ?? 0,
                        onChanged: (value) {
                          controller.changeDocumentFilter(
                              value == null || value == 0 ? null : value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: CustemDropDownField<String>(
                        items: [
                          for (final e in {
                            'all': 'الكل'.tr,
                            'code': 'مقننة'.tr,
                            'non_codified': 'غير مقننة'.tr,
                          }.entries)
                            DropdownMenuItem<String>(
                              value: e.key,
                              child: Text(
                                e.value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        value: controller.partFilter,
                        onChanged: controller.changePartFilter,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: SearchField(
                        onChanged: controller.filterData,
                        hint: "search".tr,
                        vertical: 5,
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
                              rows: controller.pagedData
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                TaxArticleModel item = entry.value;

                                int realIndex = controller.currentPage *
                                        controller.rowsPerPage +
                                    index +
                                    1;

                                return DataRow(
                                  cells: [
                                    DataCell(Text(realIndex.toString())),
                                    DataCell(
                                      SizedBox(
                                        width: 140,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.localizedLabel,
                                              softWrap: true,
                                            ),
                                            if (item.missingTranslation)
                                              Text(
                                                'بدون ترجمة إنجليزية'.tr,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      Colors.orange.shade700,
                                                ),
                                              ),
                                            if (item.tablesCount > 0)
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.table_chart_outlined,
                                                      size: 14,
                                                      color: AppColor.acteve),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${item.tablesCount} ${'جدول'.tr}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.acteve),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          item.localizedDocumentTitle ?? '-',
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      item.isRepealed
                                          ? Text('ملغاة'.tr,
                                              style: const TextStyle(
                                                  color: Colors.red))
                                          : Text('سارية'.tr,
                                              style: const TextStyle(
                                                  color: Colors.green)),
                                    ),
                                    DataCell(Text(_pages(item))),
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
                                                message: "هل أنت متأكد من حذف المادة؟".tr,
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
                                                builder: (context) => TaxArticleDialog(
                                                  mode: TaxArticleDialogMode.edit,
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
                                            onTap: () => _showDetails(context, item),
                                          ),
                                          if (item.tablesCount > 0) ...[
                                            const SizedBox(width: 10),
                                            TaxActionIcon(
                                              icon: Icons.table_chart_outlined,
                                              color: Colors.amber.shade700,
                                              tooltip: 'عرض الجداول'.tr,
                                              onTap: () => _showTables(context, item),
                                            ),
                                          ],
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
      DataColumn(label: Text("المادة".tr)),
      DataColumn(label: Text("الملف".tr)),
      DataColumn(label: Text("الحالة".tr)),
      DataColumn(label: Text("الصفحة".tr)),
      DataColumn(label: Text('إجراءات'.tr)),
    ];
  }
}
