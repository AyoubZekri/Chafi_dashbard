import 'package:chafi_dashboard/controller/ActivitiesController.dart';
import 'package:chafi_dashboard/data/model/ActivitysModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/class/Statusrequest.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/LabeledTextField.dart';

class Custemactivitysdealog extends StatefulWidget {
  final ActivityDialogMode mode;
  final Activitiescontroller controller;
  final int? id;

  const Custemactivitysdealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<Custemactivitysdealog> createState() => _CustemactivitysdealogState();
}

class _CustemactivitysdealogState extends State<Custemactivitysdealog> {
  bool get isEdit => widget.mode == ActivityDialogMode.edit;

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
                  isEdit ? 'edit'.tr : 'add_new_activity'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // أسماء النشاط
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editnamear
                            : widget.controller.namear,
                        label: "name_ar".tr,
                        hintText: "enter_name_here".tr,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editnamefr
                            : widget.controller.namefr,
                        label: "name_fr".tr,
                        hintText: "enter_name_here".tr,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // وصف النشاط
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editbodyar
                            : widget.controller.bodyar,
                        maxLines: 3,
                        label: "وصف لي النشاط بي العربية".tr,
                        hintText: "ادخل وصف لي نشاط بي العربية".tr,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editbodyfr
                            : widget.controller.bodyfr,
                        maxLines: 3,
                        label: "وصف لي النشاط بي الفرنسية".tr,
                        hintText: "ادخل وصف لي نشاط بي الفرنسية".tr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustemtextfromfildInfoUser(
                  myController: isEdit
                      ? widget.controller.editcodeActeve
                      : widget.controller.codeActeve,
                  label: "رمز النشاط".tr,
                  hintText: "رمز النشاط".tr,
                ),

                const SizedBox(height: 15),

                // Dropdown حالة النظام الجائي
                Dropdownfild(
                  label: "حالة الظام الجائي".tr,
                  hintText: "حالة الظام الجائي".tr,
                  items: widget.controller.statusTaxList
                      .map(
                        (f) => DropdownMenuItem<int>(
                          value: f["key"] as int,
                          child: Text(
                            f["label"].toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  value: widget.controller.statusTax,
                  onChanged: (val) {
                    setState(() {
                      widget.controller.statusTax = val;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // Dropdown نوع النشاط
                Dropdownfild(
                  label: "select_activity_type".tr,
                  hintText: "select_activity_type".tr,
                  items: widget.controller.typeActivity
                      .map(
                        (f) => DropdownMenuItem<int>(
                          value: f.id,
                          child: Text(
                            f.localizedName.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  value: widget.controller.selecttypeTheActivity,
                  onChanged: (val) {
                    setState(() {
                      widget.controller.selecttypeTheActivity = val;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // Dropdown النظام الضريبي
                Dropdownfild(
                  label: "select_system".tr,
                  hintText: "select_system".tr,
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
                  value: widget.controller.selectedsestemTax,
                  onChanged: (val) {
                    setState(() {
                      widget.controller.selectedsestemTax = val;
                    });
                  },
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

class ActivityIndexDialog extends StatelessWidget {
  final Activitiescontroller controller;
  final ActivityModel activityModel;

  const ActivityIndexDialog({
    super.key,
    required this.controller,
    required this.activityModel,
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
                      controller.editindex(activityModel.id);
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

enum ActivityDialogMode { add, edit }
