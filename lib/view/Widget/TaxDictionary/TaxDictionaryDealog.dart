import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/TaxDictionaryController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
import '../../../core/functions/valiedinput.dart';
import '../../../data/model/DifferantModel.dart';
import '../TextFild/LabeledTextField.dart';

class TaxDictionaryDealog extends StatelessWidget {
  final TaxDictionaryDealogMode mode;
  final TaxDictionaryControllerImp controller;
  final int? id;

  const TaxDictionaryDealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  bool get isEdit => mode == TaxDictionaryDealogMode.edit;

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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEdit ? "edit".tr : 'add_new'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // الصف الأول: العنوان
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlear
                            : controller.titlear,
                        label: 'title_ar'.tr,
                        hintText: 'title_hint'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlefr
                            : controller.titlefr,
                        label: 'title_fr'.tr,
                        hintText: 'title_hint'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // الصف الثاني: الوصف
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.editinfoar
                            : controller.infoar,
                        label: 'content_ar'.tr,
                        hintText: 'content_hint'.tr,
                        maxLines: 4,
                        valid: (val) => validateInput(val!, 2, 1000, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.editinfofr
                            : controller.infofr,
                        label: 'content_fr'.tr,
                        hintText: 'content_hint'.tr,
                        maxLines: 4,
                        valid: (val) => validateInput(val!, 2, 1000, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // أزرار التحكم
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: Get.back,
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GetBuilder<TaxDictionaryControllerImp>(
                      builder: (_) => ElevatedButton(
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
                        child: controller.statusrequest == Statusrequest.loadeng
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'add'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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

enum TaxDictionaryDealogMode { add, edit }

class TaxDictionaryIndexDialog extends StatelessWidget {
  final TaxDictionaryControllerImp controller;
  final DifferentsModel appointmentsmodel;

  const TaxDictionaryIndexDialog({
    super.key,
    required this.controller,
    required this.appointmentsmodel,
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
                'تعديل الترتيب'.tr,
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
                      backgroundColor: AppColor.typography,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      controller.editindex(appointmentsmodel.id);
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
