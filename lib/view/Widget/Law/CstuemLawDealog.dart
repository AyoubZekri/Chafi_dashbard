import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controller/LawController.dart';
import '../../../core/functions/valiedinput.dart';
import '../../../data/model/LawModel.dart';
import '../TextFild/CustomFilePickerField.dart';
import '../TextFild/LabeledTextField.dart';

class LawDialog extends StatelessWidget {
  final LawDialogMode mode;
  final Lawcontroller controller;
  final int? lawId;

  const LawDialog({
    super.key,
    required this.mode,
    required this.controller,
    this.lawId,
  });

  bool get isEdit => mode == LawDialogMode.edit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'تعديل القانون' : 'إضافة قانون',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.editNameAr
                            : controller.nameAr,
                        label: 'law_name_ar'.tr,
                        hintText: 'law_name'.tr,
                        valid: (val) => validateInput(val!, 0, 300, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.editNameFr
                            : controller.nameFr,
                        label: 'law_name_fr'.tr,
                        hintText: 'law_name'.tr,
                        valid: (val) => validateInput(val!, 0, 300, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                CustomFilePickerField(
                  label: 'upload_file'.tr,
                  hintText: 'choose_file'.tr,
                  controller: isEdit
                      ? controller.editFileController
                      : controller.fileController,
                  onPickFile: () {
                    controller.uploadimagefile();
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6269F2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (isEdit) {
                          controller.editdata(lawId!);
                        } else {
                          controller.adddata();
                        }
                      },
                      child: Text(
                        'save'.tr,
                        style: const TextStyle(color: Colors.white),
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

class LawIndexDialog extends StatelessWidget {
  final Lawcontroller controller;
  final LawModel law;

  const LawIndexDialog({
    super.key,
    required this.controller,
    required this.law,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formState,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تعديل الترتيب',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              CustemtextfromfildInfoUser(
                myController: controller.index,
                label: 'classement'.tr,
                hintText: 'classement'.tr,
                valid: (val) => validateInput(val!, 1, 6, "number"),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6269F2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      controller.editindex(law.id);
                    },
                    child: Text(
                      'save'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





enum LawDialogMode { add, edit }



