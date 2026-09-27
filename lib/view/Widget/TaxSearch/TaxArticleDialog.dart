import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TaxArticlesController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/LabeledTextField.dart';
import 'TaxTableEditor.dart';

enum TaxArticleDialogMode { add, edit }

class TaxArticleDialog extends StatefulWidget {
  final TaxArticleDialogMode mode;
  final TaxArticlesController controller;
  final int? id;

  const TaxArticleDialog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<TaxArticleDialog> createState() => _TaxArticleDialogState();
}

class _TaxArticleDialogState extends State<TaxArticleDialog> {
  bool get isEdit => widget.mode == TaxArticleDialogMode.edit;
  TaxArticlesController get controller => widget.controller;

  // Dropdownfild لا يدعم validator، لذلك نعرض الخطأ يدوياً
  bool documentError = false;

  String? _optionalNumber(String? val) {
    if (val == null || val.trim().isEmpty) return null;
    return validateInput(val.trim(), 1, 9, "number");
  }

  Widget _numberField(String label, TextEditingController c) {
    return CustemtextfromfildInfoUser(
      hintText: label,
      label: label,
      keyboardType: TextInputType.number,
      myController: c,
      valid: _optionalNumber,
    );
  }

  void _submit() {
    final valid = controller.formState.currentState!.validate();
    setState(() => documentError = controller.formDocumentId == null);
    if (!valid || documentError) return;
    if (isEdit) {
      controller.editdata(widget.id!);
    } else {
      controller.adddata();
    }
  }

  Future<void> _confirmRemoveTable(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تنبيه'.tr),
        content: Text('هل أنت متأكد من حذف هذا الجدول؟'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr, style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) setState(() => controller.removeTable(index));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 900,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEdit ? 'تعديل المادة'.tr : 'إضافة مادة جديدة'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // الملف + الجزء
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Dropdownfild<int>(
                            label: 'الملف'.tr,
                            hintText: 'اختر الملف'.tr,
                            items: controller.documents
                                .map((doc) => DropdownMenuItem<int>(
                                      value: doc.id,
                                      child: Text(
                                        doc.localizedTitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            value: controller.documents.any(
                                    (d) => d.id == controller.formDocumentId)
                                ? controller.formDocumentId
                                : null,
                            onChanged: (val) => setState(() {
                              controller.formDocumentId = val;
                              documentError = false;
                            }),
                          ),
                          if (documentError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 6, right: 12),
                              child: Text(
                                "الحقل لا يمكن أن يكون فارغًا".tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Dropdownfild<String>(
                        label: 'الجزء'.tr,
                        hintText: 'الجزء'.tr,
                        items: [
                          DropdownMenuItem(
                            value: 'code',
                            child: Text('مقنن'.tr,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: 'non_codified',
                            child: Text('غير مقنن'.tr,
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                        value: controller.formPart,
                        onChanged: (val) => setState(
                            () => controller.formPart = val ?? 'code'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // التسمية + الرقم
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustemtextfromfildInfoUser(
                        hintText: 'مثال: المادة 12 مكرر'.tr,
                        label: 'التسمية'.tr,
                        myController: controller.labelController,
                        valid: (val) => validateInput(val!, 1, 255, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        hintText: 'مثال: 12 مكرر'.tr,
                        label: 'رقم المادة'.tr,
                        myController: controller.numberController,
                        valid: (val) => val == null || val.isEmpty
                            ? null
                            : validateInput(val, 1, 100, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _numberField(
                          'الرقم (عدد)'.tr, controller.numberIntController),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                CustemtextfromfildInfoUser(
                  hintText: 'اكتب نص المادة هنا'.tr,
                  label: 'نص المادة'.tr,
                  maxLines: 8,
                  myController: controller.textController,
                  valid: (val) => validateInput(val!, 1, 16000000, "text"),
                ),
                const SizedBox(height: 15),

                // الترتيب + الصفحات + الحالة
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _numberField(
                          'الترتيب'.tr, controller.sortOrderController),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _numberField(
                          'صفحة البداية'.tr, controller.pageStartController),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _numberField(
                          'صفحة النهاية'.tr, controller.pageEndController),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Dropdownfild<bool>(
                        label: 'الحالة'.tr,
                        hintText: 'الحالة'.tr,
                        items: [
                          DropdownMenuItem(
                            value: false,
                            child: Text('سارية'.tr,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Text('ملغاة'.tr,
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                        value: controller.formIsRepealed,
                        onChanged: (val) => setState(
                            () => controller.formIsRepealed = val ?? false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // الجداول
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'الجداول'.tr} (${controller.formTables.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColor.grey,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => setState(controller.addTable),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text('إضافة جدول'.tr),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.typography,
                        side: const BorderSide(color: AppColor.typography),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < controller.formTables.length; i++)
                  TaxTableEditor(
                    key: ObjectKey(controller.formTables[i]),
                    table: controller.formTables[i],
                    index: i,
                    total: controller.formTables.length,
                    onChanged: controller.markTablesChanged,
                    onMove: (newIndex) =>
                        setState(() => controller.moveTable(i, newIndex)),
                    onRemove: () => _confirmRemoveTable(i),
                  ),

                const SizedBox(height: 30),

                // الأزرار
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
                        backgroundColor: AppColor.typography,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _submit,
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
  }
}
