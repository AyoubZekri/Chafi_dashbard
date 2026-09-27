import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TaxSearchController.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/CustomFilePickerField.dart';
import '../TextFild/LabeledTextField.dart';

enum TaxSearchDialogMode { add, edit }

class TaxSearchDialog extends StatefulWidget {
  final TaxSearchDialogMode mode;
  final TaxSearchController controller;
  final int? id;

  const TaxSearchDialog({
    Key? key,
    required this.mode,
    required this.controller,
    this.id,
  }) : super(key: key);

  @override
  State<TaxSearchDialog> createState() => _TaxSearchDialogState();
}

class _TaxSearchDialogState extends State<TaxSearchDialog> {
  // removed file picker

  @override
  Widget build(BuildContext context) {
    bool isAdd = widget.mode == TaxSearchDialogMode.add;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: widget.controller.formState,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isAdd ? 'إضافة ملف جديد'.tr : 'تعديل الملف'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D596C),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CustemtextfromfildInfoUser(
                            hintText: 'عنوان (العربية)'.tr,
                            label: 'عنوان (العربية)'.tr,
                            myController: isAdd
                                ? widget.controller.titlear
                                : widget.controller.edittitlear,
                            valid: (val) =>
                                validateInput(val!, 1, 300, "text"),
                          ),
                          const SizedBox(height: 16),
                          CustemtextfromfildInfoUser(
                            hintText: 'الرمز (Code)'.tr,
                            label: 'الرمز (Code)'.tr,
                            myController: isAdd
                                ? widget.controller.codeController
                                : widget.controller.editcodeController,
                            valid: (val) =>
                                validateInput(val!, 1, 64, "text"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          CustemtextfromfildInfoUser(
                            hintText: 'العنوان (الفرنسية)'.tr,
                            label: 'العنوان (الفرنسية)'.tr,
                            myController: isAdd
                                ? widget.controller.titlefr
                                : widget.controller.edittitlefr,
                            valid: (val) =>
                                validateInput(val!, 1, 300, "text"),
                          ),
                          const SizedBox(height: 16),
                          CustemtextfromfildInfoUser(
                            hintText: 'السنة (Year)'.tr,
                            label: 'السنة (Year)'.tr,
                            myController: isAdd
                                ? widget.controller.yearController
                                : widget.controller.edityearController,
                            valid: (val) =>
                                validateInput(val!, 1, 4, "text"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustemtextfromfildInfoUser(
                  hintText: 'التفاصيل'.tr,
                  label: 'التفاصيل'.tr,
                  maxLines: 5,
                  myController: isAdd
                      ? widget.controller.preambleController
                      : widget.controller.editPreambleController,
                  valid: (val) => validateInput(val!, 1, 5000, "text"),
                ),
                const SizedBox(height: 16),
                CustomFilePickerField(
                  label: 'الملف (PDF / Word)'.tr,
                  hintText: 'choose_file'.tr,
                  controller: isAdd
                      ? widget.controller.fileController
                      : widget.controller.editFileController,
                  onPickFile: () => widget.controller.pickFile(edit: !isAdd),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Get.back(),
                      child: Text('إلغاء'.tr),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.typography,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (isAdd) {
                          widget.controller.adddata();
                        } else {
                          widget.controller.editdata(widget.id!);
                        }
                      },
                      child: Text(isAdd ? 'حفظ'.tr : 'تعديل'.tr),
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
