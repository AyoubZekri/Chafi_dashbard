import 'package:chafi_dashboard/controller/NatureoftheactivityController.dart';
import 'package:chafi_dashboard/core/constant/Colorapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controller/BonusesAndCompensationsController.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/LabeledTextField.dart';

class Cstuembonusesandcompensationsdealog extends StatelessWidget {
  final BonusesandcompensationsDialogMode mode;
  final Bonusesandcompensationscontroller controller;
  final int? id;

  const Cstuembonusesandcompensationsdealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  bool get isEdit => mode == BonusesandcompensationsDialogMode.edit;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Bonusesandcompensationscontroller>(
      init: controller,
      global: false,
      builder: (controller) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formState,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEdit ? 'edit'.tr : 'add_new'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    CustemtextfromfildInfoUser(
                      myController: isEdit
                          ? controller.editnamear
                          : controller.namear,
                      label: "name_ar".tr,
                      hintText: 'enter_name_here'.tr,
                      valid: (val) => validateInput(val!, 1, 50, "text"),
                    ),

                    const SizedBox(height: 15),

                    CustemtextfromfildInfoUser(
                      myController: isEdit
                          ? controller.editnamefr
                          : controller.namefr,
                      label: "name_fr".tr,
                      hintText: 'enter_name_here'.tr,
                      valid: (val) => validateInput(val!, 1, 50, "text"),
                    ),

                    const SizedBox(height: 20),

                    Dropdownfild(
                      label: 'الفئة'.tr,
                      hintText: 'إختر الفئة المناسبة'.tr,
                      items: controller.cat
                          .map(
                            (f) => DropdownMenuItem<int>(
                              value: f['key'] as int,
                              child: Text(
                                f['label'].toString().tr,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      value: isEdit
                          ? controller.editselectcats
                          : controller.selectcats,
                      onChanged: (value) {
                        if (isEdit) {
                          controller.editselectcats = value;
                        } else {
                          controller.selectcats = value;
                        }
                        controller.update();
                      },
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
                            backgroundColor: AppColor.typography,
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
                              controller.editdata(id!);
                            } else {
                              controller.adddata();
                            }
                          },
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
    );
  }
}

enum BonusesandcompensationsDialogMode { add, edit }
