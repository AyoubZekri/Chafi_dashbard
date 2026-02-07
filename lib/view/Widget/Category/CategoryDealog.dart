import 'package:chafi_dashboard/controller/TaxCollection/JoiningCategoriesController.dart';
import 'package:chafi_dashboard/data/model/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/class/Statusrequest.dart';
import '../../../core/functions/valiedinput.dart';
import '../TextFild/DropdownFild.dart';
import '../TextFild/LabeledTextField.dart';

class Categorydealog extends StatefulWidget {
  final Categorydealogmode mode;
  final JoiningcategoriescontrollerImp controller;
  final int? id;

  const Categorydealog({
    super.key,
    required this.mode,
    required this.controller,
    this.id,
  });

  @override
  State<Categorydealog> createState() => _CategorydealogState();
}

class _CategorydealogState extends State<Categorydealog> {
  bool get isEdit => widget.mode == Categorydealogmode.edit;

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
                  isEdit ? 'تعديل فئة'.tr : 'إضافة فئة جديدة'.tr,
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
                            ? widget.controller.edittitleAr
                            : widget.controller.titleAr,
                        label: 'إسم الفئة بي العربية'.tr,
                        hintText: 'إسم الفئة'.tr,
                        valid: (val) =>validateInput(val!, 2, 100, "text") ,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: CustemtextfromfildInfoUser(
                        myController: isEdit
                            ? widget.controller.edittitleFr
                            : widget.controller.titleFr,
                        label: 'إسم الفئة بي الفرنسية'.tr,
                        hintText: 'إسم الفئة'.tr,
                        valid: (val) =>validateInput(val!, 2, 100, "text") ,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Dropdownfild(
                  label: 'نظام الفئة'.tr,
                  hintText: 'إختر نظام الفئة'.tr,
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
                          ? widget.controller.editselectedsestemTax = value!
                          : widget.controller.selectedsestemTax = value!;
                    });
                  },
                ),
                const SizedBox(height: 15),

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
                              'seve'.tr,
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

class CategoryIndexDialog extends StatelessWidget {
  final JoiningcategoriescontrollerImp controller;
  final CategoryModel categorymodel;

  const CategoryIndexDialog({
    super.key,
    required this.controller,
    required this.categorymodel,
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
                      controller.editindex(categorymodel.id);
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

enum Categorydealogmode { add, edit }
