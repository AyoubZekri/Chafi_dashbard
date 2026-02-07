import 'package:chafi_dashboard/controller/ActivitiesController.dart';
import 'package:chafi_dashboard/controller/AppointmentscommitmentsController.dart';
import 'package:chafi_dashboard/data/model/ActivitysModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/class/Statusrequest.dart';
import '../../../core/functions/valiedinput.dart';
import '../../../data/model/AppointmentsModel.dart';
import '../TextFild/CustemDatePickerInfoUser.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/LabeledTextField.dart';

class Appointmentsdealog extends StatefulWidget {
  final AppointmentsdealogMode mode;
  final AppointmentscommitmentscontrollerImp controller;
  final int? id;

  const Appointmentsdealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<Appointmentsdealog> createState() => _CustemactivitysdealogState();
}

class _CustemactivitysdealogState extends State<Appointmentsdealog> {
  bool get isEdit => widget.mode == AppointmentsdealogMode.edit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: widget.controller.formState,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEdit ? "edit".tr : 'add_new_commitment'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // الصف الأول: نوع التصريح
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.edittypeAr
                            : widget.controller.typeAr,
                        label: 'type_ar'.tr,
                        hintText: 'type_hint_ar'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.edittypeFr
                            : widget.controller.typeFr,
                        label: 'type_fr'.tr,
                        hintText: 'type_hint_fr'.tr,
                        valid: (val) => validateInput(val!, 2, 100, "text"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Dropdownfild(
                  label: 'system_tax'.tr,
                  hintText: 'system_tax_hint'.tr,
                  items: widget.controller.sestemTax
                      .map(
                        (f) => DropdownMenuItem<int>(
                          value: f['key'] as int,
                          child: Text(
                            f['label'].toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  value: isEdit
                      ? widget.controller.editselectedsestemTax
                      : widget.controller.selectedsestemTax,
                  onChanged: (value) {
                    setState(() {
                      isEdit
                          ? widget.controller.editselectedsestemTax
                          : widget.controller.selectedsestemTax = value!;
                    });
                  },
                ),
                const SizedBox(height: 15),

                CustemDatePickerInfoUser(
                  label: 'deadline'.tr,
                  hintText: 'deadline_hint'.tr,
                  myController: isEdit
                      ? widget.controller.editdeadline
                      : widget.controller.deadline,
                  context: context,
                ),
                const SizedBox(height: 15),

                // الصف الثالث: التبعيات
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editconsequencesAr
                            : widget.controller.consequencesAr,
                        label: 'consequences_ar'.tr,
                        hintText: "consequences_ar".tr,
                        valid: (val) => validateInput(val!, 2, 1000, "text"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editconsequencesFr
                            : widget.controller.consequencesFr,
                        label: 'consequences_fr'.tr,
                        hintText: 'consequences_fr'.tr,
                        valid: (val) => validateInput(val!, 2, 1000, "text"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                CustemDatePickerInfoUser(
                  label: 'notice_date'.tr,
                  hintText: 'notice_date_hint'.tr,
                  myController: widget.controller.noticeDate,
                  context: context,
                ),

                const SizedBox(height: 30),

                // أزرار التحكم
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
                          widget.controller.editdata(widget.id!);
                        } else {
                          widget.controller.adddata();
                        }
                      },
                      child:
                          widget.controller.statusrequest ==
                              Statusrequest.loadeng
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'add_commitment'.tr,
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

class AppointmentsIndexDialog extends StatelessWidget {
  final AppointmentscommitmentscontrollerImp controller;
  final Appointmentsmodel appointmentsmodel;

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

enum AppointmentsdealogMode { add, edit }
