import 'package:chafi_dashboard/controller/ActivitiesController.dart';
import 'package:chafi_dashboard/controller/AppointmentscommitmentsController.dart';
import 'package:chafi_dashboard/data/model/ActivitysModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/class/Statusrequest.dart';
import '../../../core/constant/Colorapp.dart';
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
                            f['label'].toString().tr,
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التواريخ'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColor.typography),
                      onPressed: () {
                        setState(() {
                          if (isEdit) {
                            widget.controller.addEditDatePair();
                          } else {
                            widget.controller.addDatePair();
                          }
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    var list = isEdit ? widget.controller.editdateControllers : widget.controller.dateControllers;
                    return Column(
                      children: List.generate(list.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustemDatePickerInfoUser(
                                  label: 'الموعد'.tr,
                                  hintText: 'الموعد'.tr,
                                  isDayMonthOnly: true,
                                  controller: list[index].appointmentDate,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustemDatePickerInfoUser(
                                  label: 'التنبيه'.tr,
                                  hintText: 'التنبيه'.tr,
                                  isDayMonthOnly: true,
                                  controller: list[index].alertDate,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (isEdit) {
                                      widget.controller.removeEditDatePair(index);
                                    } else {
                                      widget.controller.removeDatePair(index);
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  }
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

enum AppointmentsdealogMode { add, edit }

class AppointmentsDatesListDialog extends StatelessWidget {
  final Appointmentsmodel appointmentsmodel;

  const AppointmentsDatesListDialog({
    super.key,
    required this.appointmentsmodel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التواريخ والتنبيهات'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (appointmentsmodel.appointmentDates.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('لا توجد تواريخ'.tr, style: const TextStyle(color: Colors.grey)),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: appointmentsmodel.appointmentDates.length,
                  itemBuilder: (context, index) {
                    final dateItem = appointmentsmodel.appointmentDates[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('الموعد'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(dateItem.appointmentDate.isEmpty ? '-' : dateItem.appointmentDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('التنبيه'.tr, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(dateItem.alertDate.isEmpty ? '-' : dateItem.alertDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.typography,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Get.back(),
                child: Text('cancel'.tr, style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
