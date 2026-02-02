import 'package:chafi_dashboard/controller/ExternallinksController.dart';
import 'package:chafi_dashboard/data/model/DifferantModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controller/NotificationController.dart';
import '../../../core/class/Statusrequest.dart';
import '../TextFild/CustemDatePickerInfoUser.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/LabeledTextField.dart';
import '../institutions/ToggleRow.dart';

class Notificationdealog extends StatefulWidget {
  final NotificationdealogMode mode;
  final Notificationcontroller controller;
  final int? id;

  const Notificationdealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<Notificationdealog> createState() => _NotificationdealogState();
}

class _NotificationdealogState extends State<Notificationdealog> {
  bool get isEdit => widget.mode == NotificationdealogMode.edit;

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
                  isEdit ? 'تعديل اشعار'.tr : 'إضافة اشعار جديد'.tr,
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
                            ? widget.controller.editnamear
                            : widget.controller.namear,
                        label: 'title_ar'.tr,
                        hintText: 'title_hint'.tr,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.editnamefr
                            : widget.controller.namefr,
                        label: 'title_fr'.tr,
                        hintText: 'title_hint'.tr,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // الصف الثاني: المحتوى
                Row(
                  children: [
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        maxLines: 3,
                        myController: isEdit
                            ? widget.controller.editbodyar
                            : widget.controller.bodyar,
                        label: 'الحتوى بالغة العربية'.tr,
                        hintText: 'أدخل المحتوى هنا'.tr,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        maxLines: 3,
                        myController: isEdit
                            ? widget.controller.editbodyfr
                            : widget.controller.bodyfr,
                        label: 'الحتوى بالغة الفرنسية'.tr,
                        hintText: 'أدخل المحتوى هنا'.tr,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ToggleRow
                ToggleRow(
                  label: "خاص بي الانظمة".tr,
                  value: widget.controller.isSistem,
                  onChanged: (val) {
                    setState(() {
                      widget.controller.isSistem = val;
                      if (isEdit) {
                        widget.controller.editselectedsestemTax = null;
                      } else {
                        widget.controller.selectedsestemTax = null;
                      }
                    });
                  },
                ),

                // Dropdown النظام
                if (widget.controller.isSistem)
                  Dropdownfild(
                    label: "إختر النظام".tr,
                    hintText: "إختر النظام".tr,
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
                    onChanged: (val) {
                      setState(() {
                        if (isEdit) {
                          widget.controller.editselectedsestemTax = val!;
                        } else {
                          widget.controller.selectedsestemTax = val!;
                        }
                      });
                    },
                  ),

                const SizedBox(height: 15),

                // Dropdown نوع الإشعار
                Dropdownfild(
                  label: "إختر نوع الإشعر".tr,
                  hintText: "إختر نوع الإشعر".tr,
                  items: widget.controller.typenotification
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
                      ? widget.controller.editselectedTypeNotification
                      : widget.controller.selectedTypeNotification,
                  onChanged: (val) {
                    setState(() {
                      if (isEdit) {
                        widget.controller.setEditNotisication(val!);
                      } else {
                        widget.controller.setNotisication(val!);
                      }
                    });
                  },
                ),

                const SizedBox(height: 15),

                CustemDatePickerInfoUser(
                  label: 'اختر تاريخ التنبيه'.tr,
                  hintText: 'إختر تاريخ التنبيه'.tr,
                  myController:
                      isEdit ? widget.controller.editTimer : widget.controller.Timer,
                  context: context,
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
                      child: widget.controller.statusrequest == Statusrequest.loadeng
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


enum NotificationdealogMode { add, edit }

