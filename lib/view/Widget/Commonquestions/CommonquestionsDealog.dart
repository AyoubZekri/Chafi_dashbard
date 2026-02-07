import 'package:chafi_dashboard/controller/AppointmentscommitmentsController.dart';
import 'package:chafi_dashboard/data/model/DifferantModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controller/CommonquestionsController.dart';
import '../../../core/class/Statusrequest.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/LabeledTextField.dart';

class Commonquestionsdealog extends StatelessWidget {
  final CommonquestionsdealogMode mode;
  final CommonquestionscontrollerImp controller;
  final int? id;

  const Commonquestionsdealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  bool get isEdit => mode == CommonquestionsdealogMode.edit;

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
                  isEdit ? "edit".tr : 'new_question'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // الصف الأول: الأسئلة
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlear
                            : controller.titlear,
                        label: 'question_ar'.tr,
                        hintText: 'question_hint_ar'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.edittitlefr
                            : controller.titlefr,
                        label: 'question_fr'.tr,
                        hintText: 'question_hint_fr'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // الصف الثاني: الأجوبة
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? controller.editinfoar
                            : controller.infoar,
                        label: 'answer_ar'.tr,
                        hintText: 'answer_hint_ar'.tr,
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
                        label: 'answer_fr'.tr,
                        hintText: 'answer_hint_fr'.tr,
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
                    GetBuilder<CommonquestionscontrollerImp>(
                      builder: (_) => ElevatedButton(
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

enum CommonquestionsdealogMode { add, edit }

class AppointmentsIndexDialog extends StatelessWidget {
  final CommonquestionscontrollerImp controller;
  final DifferentsModel appointmentsmodel;

  const AppointmentsIndexDialog({
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
